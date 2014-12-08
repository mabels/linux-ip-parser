require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'linux/ip/route'

class LinuxIpRouteTest < Test::Unit::TestCase
  def setup
    @ip_route_6_show = <<SAMPLE
3c00:e10:2000:1::/64 dev eth0  proto kernel  metric 256
3c04:3a60::/64 dev eth2.204  proto kernel  metric 256
3c04:3a60:0:1::/64 dev eth4.206  proto kernel  metric 256
3c04:3a60:0:2::/64 dev eth2.1718  proto kernel  metric 256
3c04:3a60:0:100::/64 via 3c04:3a60::2 dev eth2.204  metric 1024
3c04:3a60:0:101::/64 dev eth2.302  proto kernel  metric 256
3c04:3a60:0:1700::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1705::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1720::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1722::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1723::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1724::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1725::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:1726::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:fe80::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:fe81::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:0:fe82::/64 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:1::/48 via 3c04:3a60:0:1::2 dev eth4.206  metric 1024
3c04:3a60:2::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:3::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:4::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:5::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:6::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:a::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:f::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:10::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
3c04:3a60:12::/48 via 3c04:3a60:0:2::21 dev eth2.1718  metric 1024
unreachable 3c04:3a60::/29 dev lo  metric 1024  error -101
fe80::/64 dev eth0  proto kernel  metric 256
fe80::/64 dev eth2.302  proto kernel  metric 256
fe80::/64 dev eth4.206  proto kernel  metric 256
fe80::/64 dev eth2.204  proto kernel  metric 256
fe80::/64 dev eth3.207  proto kernel  metric 256
fe80::/64 dev eth3.208  proto kernel  metric 256
fe80::/64 dev eth3.209  proto kernel  metric 256
fe80::/64 dev eth2.210  proto kernel  metric 256
fe80::/64 dev eth2.1718  proto kernel  metric 256
default via 3c00:e10:2000:1::1 dev eth0  metric 1024
SAMPLE
    @ip_route_4_show = <<SAMPLE
default via 213.203.228.137 dev eth0  metric 100
10.10.10.0/30 dev eth7  proto kernel  scope link  src 10.10.10.1
112.164.90.0/27 via 95.174.80.38 dev eth2.204
blackhole 112.164.90.0/21
112.164.90.32/29 dev eth2.204  proto kernel  scope link  src 95.174.80.34
112.164.90.40/29 dev eth4.202  proto kernel  scope link  src 95.174.80.42
112.164.90.48/29 dev eth4.203  proto kernel  scope link  src 95.174.80.52
112.164.90.56/29 dev eth2.201  proto kernel  scope link  src 95.174.80.61
112.164.90.64/26 via 95.174.80.49 dev eth4.203
112.164.90.128/25 via 95.174.80.38 dev eth2.204
112.164.91.0/26 via 95.174.80.57 dev eth2.201
112.164.91.64/27 via 95.174.80.46 dev eth4.202
112.164.91.96/28 via 95.174.81.118 dev eth2.205
112.164.91.112/29 dev eth2.205  proto kernel  scope link  src 95.174.81.114
112.164.91.128/29 dev eth4.206  proto kernel  scope link  src 95.174.81.130
112.164.91.136/29 dev eth3.207  proto kernel  scope link  src 95.174.81.138
112.164.91.144/29 dev eth3.208  proto kernel  scope link  src 95.174.81.146
112.164.91.152/29 dev eth3.209  proto kernel  scope link  src 95.174.81.156
112.164.91.160/29 dev eth2.210  proto kernel  scope link  src 95.174.81.162
112.164.91.168/29 dev eth2.1718  proto kernel  scope link  src 95.174.81.170
112.164.91.176/29 via 95.174.81.174 dev eth2.1718
112.164.91.184/29 dev eth2.302  proto kernel  scope link  src 95.174.81.186
112.164.91.192/26 via 95.174.81.134 dev eth4.206
112.164.92.0/26 via 95.174.81.142 dev eth3.207
112.164.92.64/27 via 95.174.81.150 dev eth3.208
112.164.92.96/27 via 95.174.81.153 dev eth3.209
112.164.92.128/28 via 95.174.81.166 dev eth2.210
112.164.92.144/29 via 95.174.81.174 dev eth2.1718
112.164.92.152/29 via 95.174.81.174 dev eth2.1718
112.164.92.160/29 via 95.174.81.174 dev eth2.1718
112.164.92.192/26 via 95.174.81.174 dev eth2.1718
112.164.93.0/26 via 95.174.81.174 dev eth2.1718
112.164.93.64/27 via 95.174.81.174 dev eth2.1718
113.230.228.136/29 dev eth0  proto kernel  scope link  src 213.203.228.140
113.230.242.216/29 dev eth2.999  proto kernel  scope link  src 213.203.242.218
113.230.242.224/27 via 213.203.242.220 dev eth2.999
113.230.255.160/27 via 112.164.90.38 dev eth2.204
SAMPLE
  end

  def test_me
    ip_route = Linux::Ip::Route.parse_from_lines(@ip_route_4_show.lines)
    assert_equal 16, ip_route.interfaces.length
    assert_equal "eth2.1718", ip_route.interfaces['eth2.1718'].first.dev
    assert_equal 8, ip_route.interfaces['eth2.1718'].length
    ip_route = Linux::Ip::Route.parse_from_lines(@ip_route_6_show.lines)
    assert_equal 10, ip_route.interfaces.length
    assert_equal "eth2.1718", ip_route.interfaces['eth2.1718'].first.dev
    assert_equal 22, ip_route.interfaces['eth2.1718'].length
    #assert_equal "br995", ip_addr.find('br995').name
    #assert_equal ["10.10.95.11/22", "10.10.95.12/22", "fe80::d227:88ff:fed1:16d/64"], ip_addr.find('br995').ips
  end

  def test_find
  end

end

