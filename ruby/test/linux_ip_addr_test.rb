require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
puts `pwd`
puts "----"
puts $LOAD_PATH
require 'linux/ip/addr'

class LinuxIpAddrTest < Test::Unit::TestCase
  def setup
    @ip_addr_show = <<SAMPLE
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
    link/ether 36:1b:a1:ba:73:54 brd ff:ff:ff:ff:ff:ff
4: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 74:e5:0b:d7:9d:44 brd ff:ff:ff:ff:ff:ff
5: p1p1.1507@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br1507 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
6: p1p1.995@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br995 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
7: br1507: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 126.69.140.182/26 brd 126.96.140.191 scope global br1507
       valid_lft forever preferred_lft forever
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
8: br995: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 10.10.95.11/22 brd 10.10.95.255 scope global br995
       valid_lft forever preferred_lft forever
    inet 10.10.95.12/22 scope global secondary br995
       valid_lft forever preferred_lft forever
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
9: gre0: <NOARP> mtu 1476 qdisc noop state DOWN group default
    link/gre 169.254.10.9 brd 169.254.10.10
10: gretap0: <BROADCAST,MULTICAST> mtu 1476 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
11: gt0@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN group default
    link/gre 169.254.10.1 peer 169.254.10.2
    inet 169.254.10.1/30 brd 169.254.10.3 scope global gt0
       valid_lft forever preferred_lft forever
    inet6 fe80::5efe:a9fe:a01/64 scope link
       valid_lft forever preferred_lft forever
12: gt1@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN group default
    link/gre 169.254.10.5 peer 169.254.10.6
    inet 169.254.10.5/30 brd 169.254.10.7 scope global gt1
       valid_lft forever preferred_lft forever
    inet6 fe80::5efe:a9fe:a05/64 scope link
       valid_lft forever preferred_lft forever
13: gtmia@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN group default
    link/gre 169.254.10.9 peer 169.254.10.10
    inet 169.254.10.9/30 brd 169.254.10.11 scope global gtmia
       valid_lft forever preferred_lft forever
    inet6 fe80::5efe:a9fe:a09/64 scope link
       valid_lft forever preferred_lft forever
14: p1p1.110@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br110 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
15: p1p1.201@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br201 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
16: p1p1.202@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br202 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
17: p1p1.402@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br402 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
18: p1p1.997@p1p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br997 state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d227:88ff:fed1:16d/64 scope link
       valid_lft forever preferred_lft forever
19: br110: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.11/16 brd 10.1.255.255 scope global br110
       valid_lft forever preferred_lft forever
    inet6 fe80::1046:faff:feed:ca96/64 scope link
       valid_lft forever preferred_lft forever
20: br201: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 10.10.16.11/22 brd 10.10.19.255 scope global br201
       valid_lft forever preferred_lft forever
    inet6 fe80::50ac:36ff:fe1b:24e8/64 scope link
       valid_lft forever preferred_lft forever
21: br402: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 10.10.99.11/22 brd 10.10.99.255 scope global br402
       valid_lft forever preferred_lft forever
    inet6 fe80::f41f:71ff:fe45:2e3b/64 scope link
       valid_lft forever preferred_lft forever
22: br997: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 17.110.59.53/26 brd 17.110.59.63 scope global br997
       valid_lft forever preferred_lft forever
    inet6 fe80::408e:b9ff:fe81:d1f2/64 scope link
       valid_lft forever preferred_lft forever
23: br202: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether d0:27:88:d1:01:6d brd ff:ff:ff:ff:ff:ff
    inet 10.10.103.11/22 brd 10.10.103.255 scope global br202
       valid_lft forever preferred_lft forever
    inet6 fe80::84c6:95ff:feb7:d76d/64 scope link
       valid_lft forever preferred_lft forever
30: tun2: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.153.66.129 peer 10.153.66.130/32 scope global tun2
       valid_lft forever preferred_lft forever
31: tun1: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.153.65.1 peer 10.153.65.2/32 scope global tun1
       valid_lft forever preferred_lft forever
32: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/none
    inet 10.153.65.129 peer 10.153.65.130/32 scope global tun0
       valid_lft forever preferred_lft forever
SAMPLE
  end

  def test_me
    ip_addr = Linux::Ip::Addr.parse_from_lines(@ip_addr_show.lines)
    assert_equal 26, ip_addr.length
    assert_equal "br995", ip_addr.find('br995').name
    assert_equal ["10.10.95.11/22", "10.10.95.12/22", "fe80::d227:88ff:fed1:16d/64"], ip_addr.find('br995').ips
  end

  def test_find
    require 'ipaddress'
    map = [{:net => IPAddress.parse("10.10.95.0/22"), :result => "huhu" }]
    ip_addr = Linux::Ip::Addr.parse_from_lines(@ip_addr_show.lines)
    ret = map.find do |matcher|
      ip_addr.interfaces.find do |iface|
        iface.ips.find do |ip|
          ip = IPAddress.parse(ip)
          ip.ipv4? && matcher[:net].include?(ip)
        end
      end
    end
    assert_equal "huhu", ret[:result]
  end

  def test_as_commands
    ip_addr = Linux::Ip::Addr.parse_from_lines(@ip_addr_show.lines)
    assert ip_addr.as_commands("add").include?("ip addr add fe80::d227:88ff:fed1:16d/64 dev p1p1.402")
    assert ip_addr.as_commands("del").include?("ip addr del 10.1.0.11/16 dev br110")
  end

  def test_from_scratch
    ip_addr = Linux::Ip::Addr::IpAddr.new
    ip_addr.interfaces << Linux::Ip::Addr::Interface.new("eth0").add_ip("47.11.1.1/26")
    assert ip_addr.as_commands("del").include?("ip addr del 47.11.1.1/26 dev eth0")
  end

end

