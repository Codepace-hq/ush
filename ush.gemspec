
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ush/version"

Gem::Specification.new do |spec|
  spec.name          = "ush"
  spec.version       = Ush::VERSION
  spec.authors       = ["cbrnrd"]
  spec.email         = ["cbawsome77@gmail.com"]

  spec.summary       = %q{An ultra portable url shortener}
  spec.homepage      = "https://github.com/cbrnrd/ush"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra", "~> 2.0"
  spec.add_runtime_dependency('addressable', "~> 2.3.0")
  spec.add_runtime_dependency('sqlite3')


  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
