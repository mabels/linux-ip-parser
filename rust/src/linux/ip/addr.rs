
use std::collections::LinkedList;

struct Interface {
    mac_address: String,
    name: String,
    ips: Vec
}
impl Interface {
    fn add_ip(ip: &str) {
        ips.push_back(i);
        self
    }
    fn as_commands(direction) {
        ips.iter.map(|ip|
          format!("ip addr {} {} dev {}", direction, ip, self.name)
        )
    }
}

struct IpAddr {
  interfaces: Vec<Interface>
}

impl IpAddr {
  fn length() {
    interfaces.len()
  }
  fn find(name: &str) {
    interfaces.iter().find( |i| i.name == name )
  }
  fn as_commands(direction: &str) {
    let mut ret = Vec<String>::new
    for interface in interfaces {
        ret.append(interface.as_commands(direction))
    }
    ret
  }
  fn execute_add() {
    system as_commands("add")
  }
  fn execute_del() {
    system as_commands("del")
  }
}


impl Addr {
    pub fn parse_from_lines(lines: &str) -> IpAddr {
      let ip_addr = IpAddr::new {
        ips: Vec::new()
      }
      let re_crnl = Regex::new(r"[\s\n\r]+").unwrap();
      let re_line = Regex::new(r"^\d+:\s+(\S+):\s+(.*)$").unwrap();
      let re_mac_address = Regex::new(r"\s*link\/ether\s+([a-f0-9:]+)\s+.*").unwrap();
      let re_ip_addr = Regex.new(r"\s*inet[6]*\s+([0-9a-f\:\.\/]+)\s+.*").unwrap();
      let mut op_iface: Option<Interface> = None;
      for line in RegexSplits(re_crnl, lines) {
          if re_line.is_match(line) {
            op_iface = Interface.new($1.split('@')[0])
            ip_addr.interfaces << iface
        } else {
            match op_iface {
                Some(iface) => {
                    for cap in re_mac_address.captures_iter(line) {
                        iface.mac_address = cap.at(1).unwrap();
                    }
                    for cap in re_ip_addr.captures_iter(line) {
                        iface.ips.push_back(cap.at(1).unwrap());
                    }
                }
                None => {}
            }
        }
      }
      return ip_addr;
    }

    pub fn parse() {
        let out = Command::new("ip").arg("addr").arg("show").output().unwrap();
        parse_from_lines(String::from_utf8_lossy(&out.stdout))
    }
}
