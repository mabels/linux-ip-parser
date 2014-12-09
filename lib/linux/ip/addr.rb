require "linux/ip/addr/version"

module Linux
  module Ip
    module Addr

      class Interface
        attr_accessor :mac_address
        attr_reader :ips, :name
        def initialize(name)
          @name = name
          @ips = []
        end
        def add_ip(ip)
          @ips << ip
        end
      end


      class IpAddr
        attr_reader :interfaces
        def initialize
          @interfaces = []
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
        ip_addr = IpAddr.new
        iface = nil
        lines.each do |line|
            line = line.strip.chomp
            if line =~ /^\d+:\s+(\S+):\s+(.*)$/
              iface = Interface.new($1.split('@')[0])
              ip_addr.interfaces << iface
            elsif iface
              if line =~ /^\s*link\/ether\s+([a-f0-9:]+)\s+.*$/
                iface.mac_address = $1
              elsif line =~ /^\s*inet[6]*\s+([0-9a-f\:\.\/]+)\s+.*$/
                iface.add_ip($1)
              end
            end
        end
        ip_addr
      end

      def self.parse
        parse_from_lines(IO.popen("ip addr show").read.lines)
      end

    end
  end
end
