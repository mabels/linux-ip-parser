

// use regex::Regex;
// use regex::RegexSplits;
// use std::process::Command;

// use addr::Interface;

// use std::collections::LinkedList;

// mod linux {
//pub mod addr {
    use regex::Regex;
    use std::process::Command;

pub struct Interface {
    pub mac_address: Option<String>,
    pub name: String,
    pub ips: Vec<String>
}
#[allow(dead_code)]
impl Interface {
    pub fn set_mac_address(&mut self, mac: &String) {
        self.mac_address = Some(mac.clone());
    }
    pub fn add_ip(&mut self, ip: String) -> &Interface {
        self.ips.push(ip);
        self
    }
    fn as_commands(&self, direction: &str) -> Vec<String> {
    //   println!("0001");
      let ret = self.ips.iter().map(|ip|
          format!("ip addr {} {} dev {}", direction, ip, self.name)
      ).collect();
    //   println!("0002");
    //   for ip in &ret {
    //       println!("ip addr {} {} dev {}", direction, ip, self.name)
    //   }
    //   println!("0003");
      return ret
    }
}

pub struct IpAddr {
  pub interfaces: Vec<Interface>
}

#[allow(dead_code)]
impl IpAddr {
  pub fn add_interface(&mut self, name: &String) -> usize {
     //println!("interface:{}", name);
     self.interfaces.push(Interface {
         name: name.clone(),
         mac_address: None,
         ips: Vec::new()
     });
     return self.interfaces.len() - 1;
  }
  pub fn length(&self) -> usize {
    self.interfaces.len()
  }
  pub fn find(&self, name: &str) -> Option<&Interface> {
    // for i in &self.interfaces {
    //     println!("name: {} == {}", name, i.name)
    // }
    self.interfaces.iter().find( |i| i.name == name )
  }
  pub fn as_commands(&self, direction: &str) -> Vec<String> {
    //println!("--1");
    let mut ret : Vec<String> = Vec::new();
    //println!("--2");
    for interface in self.interfaces.iter() {
        //println!("--3");
        ret.append(&mut interface.as_commands(direction))
    }
    //println!("--4");
    // for i in &ret {
    //     println!(">>>{}", i);
    // }
    // println!("--5");
    return ret;
  }
  // fn execute_add() {
  //   system as_commands("add")
  // }
  // fn execute_del() {
  //   system as_commands("del")
  // }
}

pub fn parse_from_string(lines: &String) -> IpAddr {
  let mut ip_addr = IpAddr {
     interfaces: Vec::new()
  };
  let re_crnl = Regex::new(r"\s*[\n\r]+\s*").unwrap();
  let re_line = Regex::new(r"^\d+:\s+([a-zA-Z0-9\.-]+)(@\S+)*:\s+(.*)$").unwrap();
  let re_mac_address = Regex::new(r"\s*link/ether\s+([a-f0-9:]+)\s+.*").unwrap();
  let re_ip_addr = Regex::new(r"\s*inet[6]*\s+([0-9a-f:\./]+)\s+.*").unwrap();
  let mut op_iface = 0;
  let mut split = re_crnl.split(lines);
  loop {
    match split.next() {
      None => { break; },
      Some(line) => {
        //println!(">>>{}", line);
      if re_line.is_match(line) {
        for cap in re_line.captures_iter(line) {
            op_iface = ip_addr.add_interface(&cap.at(1).unwrap().to_string())
        }
    } else {
                for cap in re_mac_address.captures_iter(line) {
                    ip_addr.interfaces[op_iface].set_mac_address(&cap.at(1).unwrap().to_string());
                }
                for cap in re_ip_addr.captures_iter(line) {
                    ip_addr.interfaces[op_iface].add_ip(cap.at(1).unwrap().to_string());
                }
    }
}
}
  }
  return ip_addr
}

pub fn parse() -> IpAddr {
    let out = Command::new("ip").arg("addr").arg("show").output().unwrap();
    return parse_from_string(&String::from_utf8_lossy(&out.stdout).into_owned())
}


//}

// pub impl Addr {
// }

//}
// }
