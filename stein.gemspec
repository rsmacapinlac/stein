
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stein/version"

Gem::Specification.new do |spec|
  spec.name          = "stein"
  spec.version       = Stein::VERSION
  spec.authors       = ["Ritchie Macapinlac"]
  spec.email         = ["ritchie@macapinlac.com"]

  spec.summary       = %q{This is an automation gem for specific web platforms.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "http://www.macapinlac.com"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'selenium-webdriver'
  spec.add_dependency 'headless'
  spec.add_dependency 'dotenv'

  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
