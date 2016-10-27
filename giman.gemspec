$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "giman/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "giman"
  s.version     = Giman::VERSION
  s.authors     = ["Pete Hawkins"]
  s.email       = ["pete@phawk.co.uk"]
  s.homepage    = "https://github.com/dawsonandrews/giman"
  s.summary     = "Giman makes uploading files directly to AWS S3 a breeze."
  s.description = "Giman makes uploading files directly to AWS S3 a breeze. It supports a modern JS evented interface with built in support for drag and drop uploads."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2"
  s.add_dependency "aws-sdk", ">= 2.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"

  s.required_ruby_version = Gem::Requirement.new('>= 2.0.0')
end
