require "linux/ip/addr/version"
require 'ostruct'

module Linux
  module Ip
    module Route

      class IpRoute
        attr_reader :interfaces, :routes
        def initialize
          @interfaces = {}
          @routes = []
        end

        class Options < OpenStruct
          def initialize(options_str)
            super(options_str.split(/\s+/).inject({}) { |r, i| r[i] = true; r })
          end
        end

        class ViaRoute
          attr_reader :dst, :via, :dev, :options
          def initialize(dst, via, dev, options)
            @dst = dst
            @via = via
            @dev = dev
            @options = options
          end
        end
        def add_via(dev, dst, via, options)
          @interfaces[dev] ||= []
          route = ViaRoute.new(dst, via, dev, Options.new(options))
          @interfaces[dev] << route
          @routes << route
        end

        class IfaceRoute
          attr_reader :dst, :dev, :options
          def initialize(dst, dev, options)
            @dst = dst
            @dev = dev
            @options = options
          end
        end
        def add_dev(dev, dst, options)
          @interfaces[dev] ||= []
          route = IfaceRoute.new(dst, dev, Options.new(options))
          @interfaces[dev] << route
          @routes << route
        end

        def length
          interfaces.length
        end
        def find(name)
          interfaces.find { |i| i.name == name }
        end
      end

      #23: br202: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
      #    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
      #    inet 10.10.103.11/22 brd 10.10.103.255 scope global br202
      #       valid_lft forever preferred_lft forever
      #    inet6 fe80::84c6:95ff:feb7:d76d/64 scope link
      #       valid_lft forever preferred_lft forever
      def self.parse_from_lines(lines)
        ip_route = IpRoute.new
        iface = nil
        lines.each do |line|
            line = line.strip.chomp
            dev_m = /^([0-9a-fA-F\.\:\/]+)\s+dev\s+([a-z0-9\.]+)\s*(.*)$/.match(line)
            if dev_m
              #puts "Dev #{dev_m[2]} -> #{dev_m.inspect}"
              ip_route.add_dev(dev_m[2], dev_m[1], dev_m[3])
            else
              via_m = /^([0-9a-fA-F\.\:\/]+|default)\s+via\s+([a-z0-9\.\:]+)\s+dev\s+([a-z0-9\.]+)\s*(.*)$/.match(line)
              if via_m
                #puts "Via #{via_m[3]} -> #{via_m.inspect}"
                ip_route.add_via(via_m[3], via_m[1], via_m[2], via_m[4])
              else
                direct_m = /^(blackhole)\s+([0-9a-fA-F\.\:\/]+)$/.match(line)
                if direct_m
                  ip_route.add_via(direct_m[1], direct_m[2], nil, "")
                else
                  # unreachable 2a04:2f80::/29 dev lo  metric 1024  error -101
                  unreachable_m = /^(unreachable)\s+([0-9a-fA-F\.\:\/]+)\s+dev\s+([a-z0-9\.]+)\s+(.*)$/.match(line)
                  if unreachable_m
                    ip_route.add_dev(unreachable_m[3], unreachable_m[2], unreachable_m[1]+" "+unreachable_m[4])
                  else
                    puts "> #{line}"
                  end
                end
              end
            end
        end
        ip_route
      end

      def self.parse
        parse_from_lines(IO.popen("ip -4 route show").read.lines.to_a + IO.popen("ip -6 route show").read.lines.to_a)
      end

    end
  end
end
