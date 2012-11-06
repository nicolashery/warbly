Gem::Specification.new do |s|
  s.name          = 'warbly'
  s.version       = '0.1.0'
  s.authors       = ["Nicolas Hery"]
  s.email         = "nicolahery@gmail.com"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'chronic', '~> 0.8'
end