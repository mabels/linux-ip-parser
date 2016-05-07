
// mod Route {
use std::collections::HashSet;
use std::collections::HashMap;
use regex::Regex;
use std::process::Command;
use std::rc::Rc;


pub struct Options {
    pub options: HashSet<String>,
}

impl Options {
    pub fn new(options_str: &str) -> Options {
        let mut options = Options { options: HashSet::new() };
        let re_space = Regex::new(r"\s+").unwrap();
        for opt in re_space.split(&options_str) {
            options.options.insert(opt.to_string());
        }
        return options;
    }
    pub fn as_ip(&self) -> String {
        "".to_string() // there is some to do
    }
}

enum RouteKind {
    Via,
    Dev,
}

pub struct Route {
    dst: String,
    pub dev: String,
    options: Options,
    via: Option<String>,
    kind: RouteKind,
}
impl Route {
    fn as_commands(&self, direction: &str) -> String {
        match self.kind {
            RouteKind::Via => {
                let x = self.via.clone().unwrap_or("".to_string());
                format!("ip route {} {} via {}{}",
                        &direction,
                        &self.dst,
                        &x,
                        self.options.as_ip())
            }
            RouteKind::Dev => {
                format!("ip route {} {} dev {}{}",
                        direction,
                        &self.dst,
                        &self.dev,
                        self.options.as_ip())
            }
        }
    }
}


pub struct IpRoute {
    pub interfaces: HashMap<String, Vec<Rc<Route>>>,
    pub routes: Vec<Rc<Route>>,
}


impl IpRoute {
    pub fn as_commands(&self, direction: &str) -> Vec<String> {
        println!("--1");
        let mut ret: Vec<String> = Vec::new();
        println!("--2");
        for route in self.routes.iter() {
            let cmd = route.as_commands(direction).clone();
            println!("[{}]", &cmd);
            ret.push(cmd)
        }
        println!("--3");
        return ret;
    }

    fn add_route(&mut self, route: Rc<Route>) {
        self.routes.push(route.clone());
        let key = route.as_ref().dev.to_string();
        let _vec = self.interfaces.entry(key).or_insert(Vec::new());
        (*_vec).push(route.clone());
    }

    pub fn add_via(&mut self, dev: &str, dst: &str, via: Option<String>, options: &str) {
        self.add_route(Rc::new(Route {
            kind: RouteKind::Via,
            dev: dev.to_string(),
            dst: dst.to_string(),
            via: via,
            options: Options::new(options),
        }));
    }

    pub fn add_dev(&mut self, dev: &str, dst: &str, options: &str) {
        self.add_route(Rc::new(Route {
            kind: RouteKind::Dev,
            dst: dst.to_string(),
            dev: dev.to_string(),
            via: None,
            options: Options::new(options),
        }));
    }

    pub fn length(&self) -> usize {
        return self.routes.len();
    }
    pub fn find(&self, name: &str) -> Option<&Vec<Rc<Route>>> {
        return self.interfaces.get(&name.to_string());
    }
}



pub fn parse_from_string(lines: &str) -> IpRoute {
    let re_crnl = Regex::new(r"\s*[\n\r]+\s*").unwrap();
    let re_dev_m = Regex::new(r"^([0-9a-fA-F\.:/]+)\s+dev\s+([a-z0-9\.]+)\s*(.*)$").unwrap();
    let re_via_m = Regex::new(r"^([0-9a-fA-F\.:/]+|default)\s+via\s+([a-z0-9\.:]+)\s+dev\s+([a-z0-9\.]+)\s*(.*)$").unwrap();
    let re_direct_m = Regex::new(r"^(blackhole)\s+([0-9a-fA-F\.:/]+)$").unwrap();
    let re_unreachable_m = Regex::new(r"^(unreachable)\s+([0-9a-fA-F\.:/]+)\s+dev\s+([a-z0-9\.]+)\s+(.*)$").unwrap();
    let mut ip_route = IpRoute {
        routes: Vec::new(),
        interfaces: HashMap::new(),
    };
    let mut split = re_crnl.split(lines);
    loop {
        match split.next() {
            None => {
                break;
            }
            Some(line) => {
                if re_dev_m.is_match(line) {
                    for cap in re_dev_m.captures_iter(line) {
                        ip_route.add_dev(cap.at(2).unwrap(), cap.at(1).unwrap(), cap.at(3).unwrap())
                    }
                } else {
                    if re_via_m.is_match(line) {
                        for cap in re_via_m.captures_iter(line) {
                            ip_route.add_via(cap.at(3).unwrap(),
                                             cap.at(1).unwrap(),
                                             Some(cap.at(2).unwrap().to_string()),
                                             cap.at(4).unwrap())
                        }
                    } else {
                        if re_direct_m.is_match(line) {
                            for cap in re_direct_m.captures_iter(line) {
                                ip_route.add_via(cap.at(1).unwrap(), cap.at(2).unwrap(), None, &"")
                            }
                        } else {
                            if re_unreachable_m.is_match(line) {
                                for cap in re_unreachable_m.captures_iter(line) {
                                    ip_route.add_dev(cap.at(3).unwrap(),
                                                     cap.at(2).unwrap(),
                                                     format!("{} {}",
                                                             &cap.at(2).unwrap(),
                                                             &cap.at(4).unwrap())
                                                         .as_str())
                                }
                            } else {
                                warn!("unknown line:{}", line)
                            }
                        }
                    }
                }
            }
        }
    }
    ip_route
}



pub fn parse() -> IpRoute {
    let out_6 = Command::new("ip").arg("-6").arg("route").arg("show").output().unwrap();
    let out_4 = Command::new("ip").arg("-4").arg("route").arg("show").output().unwrap();
    return parse_from_string(format!("{}{}",
                                     &String::from_utf8_lossy(&out_4.stdout).into_owned(),
                                     &String::from_utf8_lossy(&out_6.stdout).into_owned())
        .as_str());
}
// }
