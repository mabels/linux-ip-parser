
extern crate regex;
extern crate core;

use regex::Regex;
// use regex::RegexSplits;
use std::process::Command;
// use core::ops::Index;

mod addr;

pub use addr::Interface;
pub use addr::IpAddr;
//pub use addr::Addr;

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
