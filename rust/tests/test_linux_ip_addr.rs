
extern crate linux_ip_addr;

//use std::io::prelude::*;

#[cfg(test)]
mod tests {
    use std::fs::File;
    use std::io::Read;
    use std::path::Path;

    fn ip_addr_show() -> String {
        let mut f = File::open(Path::new("tests/ip_addr.out")).unwrap();
        let mut s = String::new();
        f.read_to_string(&mut s).ok();
        return s
    }
    #[test]
    fn test_me() {
      let ip_addr = ::linux_ip_addr::parse_from_string(&ip_addr_show());
      assert_eq!(26, ip_addr.length());
      assert_eq!("br995", ip_addr.find("br995").unwrap().name);
      assert_eq!(vec!["10.10.95.11/22", "10.10.95.12/22", "fe80::d227:88ff:fed1:16d/64"], ip_addr.find("br995").unwrap().ips);
    }
#[test]
   fn test_as_commands() {
    let ip_addr = ::linux_ip_addr::parse_from_string(&ip_addr_show());
    for i in ip_addr.as_commands("add") {
        println!("cmd:{}", &i)
    }
    assert!(ip_addr.as_commands("add").iter().find(|s| *s == "ip addr add fe80::d227:88ff:fed1:16d/64 dev p1p1.402").is_some());
    assert!(ip_addr.as_commands("del").iter().find(|s| *s == "ip addr del 10.1.0.11/16 dev br110").is_some());
  }
#[test]
  fn test_from_scratch() {
    let mut ip_addr = ::linux_ip_addr::IpAddr {
        interfaces: Vec::new()
    };
    let idx = ip_addr.add_interface(&"eth0".to_string());
    ip_addr.interfaces[idx].add_ip("47.11.1.1/26".to_string());
    assert!(ip_addr.as_commands("del").iter().find(|s| *s == "ip addr del 47.11.1.1/26 dev eth0").is_some())
  }

}

  //   fn test_find() {
  //   require 'ipaddress'
  //   map = [{:net => IPAddress.parse("10.10.95.0/22"), :result => "huhu" }]
  //   ip_addr = Linux::Ip::Addr.parse_from_lines(@ip_addr_show.lines)
  //   ret = map.find do |matcher|
  //     ip_addr.interfaces.find do |iface|
  //       iface.ips.find do |ip|
  //         ip = IPAddress.parse(ip)
  //         ip.ipv4? && matcher[:net].include?(ip)
  //       end
  //     end
  //   end
  //   assert_equal "huhu", ret[:result]
  // end
