
extern crate linux_ip;

// use std::io::prelude::*;

#[cfg(test)]
mod tests {
    use std::fs::File;
    use std::io::Read;
    use std::path::Path;
    use std::collections::HashMap;

    fn ip_route_6_show() -> String {
        let mut f = File::open(Path::new("tests/ip_route_v6.out")).unwrap();
        let mut s = String::new();
        f.read_to_string(&mut s).ok();
        return s;
    }

    fn ip_route_4_show() -> String {
        let mut f = File::open(Path::new("tests/ip_route_v4.out")).unwrap();
        let mut s = String::new();
        f.read_to_string(&mut s).ok();
        return s;
    }

    #[test]
    fn test_me() {
        println!("-1");
        let mut ip_route = ::linux_ip::route::parse_from_string(&ip_route_4_show());
        println!("-2");
        assert_eq!(16, ip_route.interfaces.len());
        println!("-3");
        assert_eq!("eth2.1718",
                   ip_route.interfaces.get("eth2.1718").unwrap().first().unwrap().dev);
        println!("-4");
        assert_eq!(8, ip_route.interfaces.get("eth2.1718").unwrap().len());
        println!("-5");
        ip_route = ::linux_ip::route::parse_from_string(&ip_route_6_show());
        println!("-6");
        assert_eq!(10, ip_route.interfaces.len());
        println!("-7");
        assert_eq!("eth2.1718",
                   ip_route.interfaces.get("eth2.1718").unwrap().first().unwrap().dev);
        println!("-8");
        assert_eq!(22, ip_route.interfaces.get("eth2.1718").unwrap().len());
        println!("-9");
    }

    #[test]
    fn test_as_commands() {
        let mut ip_route = ::linux_ip::route::parse_from_string(&ip_route_4_show());
        assert!(ip_route.as_commands("del")
            .iter()
            .find(|s| *s == "ip route del 112.164.91.136/29 dev eth3.207")
            .is_some());
        ip_route = ::linux_ip::route::parse_from_string(&ip_route_6_show());
        assert!(ip_route.as_commands("add")
            .iter()
            .find(|s| *s == "ip route add 3c04:3a60:0:fe82::/64 via 3c04:3a60:0:2::21")
            .is_some());
    }
    #[test]
    fn test_from_scratch() {
        let mut ip_route = ::linux_ip::route::IpRoute {
            routes: Vec::new(),
            interfaces: HashMap::new(),
        };
        ip_route.add_via("eth0", "0.0.0.0/0", Some("47.11.1.1".to_string()), "");
        assert!(ip_route.as_commands("add")
            .iter()
            .find(|s| *s == "ip route add 0.0.0.0/0 via 47.11.1.1")
            .is_some());
        assert!(ip_route.as_commands("del")
            .iter()
            .find(|s| *s == "ip route del 0.0.0.0/0 via 47.11.1.1")
            .is_some());
    }

}
