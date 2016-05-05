

// use regex::Regex;
// use regex::RegexSplits;
// use std::process::Command;

// use addr::Interface;

// use std::collections::LinkedList;

// mod linux {
// mod ip {
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


// pub impl Addr {
// }

//}
// }
