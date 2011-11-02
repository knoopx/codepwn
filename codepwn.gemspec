# -*- encoding: utf-8 -*-
require File.expand_path('../lib/codepwn', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Víctor Martínez"]
  gem.email = ["knoopx@gmail.com"]
  gem.description = %q{Resign IPA files using user specified mobile provision}

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name = "codepwn"
  gem.require_paths = ["lib"]
  gem.version = CodePwn::VERSION

  gem.add_dependency 'thor'
  gem.add_dependency 'rubyzip'
end