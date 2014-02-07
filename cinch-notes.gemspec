# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cinch/plugins/notes/version'

Gem::Specification.new do |spec|
  spec.name          = "cinch-notes"
  spec.version       = Cinch::Plugins::Notes::VERSION
  spec.authors       = ["Brian Haberer"]
  spec.email         = ["bhaberer@gmail.com"]
  spec.description   = %q{A cinch plugin to allow leaving other users notes.}
  spec.summary       = %q{Cinch Notes Plugin}
  spec.homepage      = "https://github.com/bhaberer/cinch-note"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'cinch-test'

  spec.add_dependency             'cinch'
  spec.add_dependency             'cinch-toolbox'
  spec.add_dependency             'cinch-storage'
end
