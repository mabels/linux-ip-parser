# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linux/ip/version'

Gem::Specification.new do |spec|
  spec.name          = "linux-ip-addr"
  spec.version       = Linux::Ip::VERSION
  spec.authors       = ["Meno Abels"]
  spec.email         = ["meno.abels@adviser.com"]
  spec.summary       = %q{Parse the output of ip addr on a linux system}
  spec.description   = %q{Parse the output of ip addr on a linux system}
  spec.homepage      = "https://github.com/mabels/gem-linux-ip-addr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

#  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "ipaddress", "~> 0.8"
end
