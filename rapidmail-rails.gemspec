$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rapidmail/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rapidmail-rails"
  s.version     = Rapidmail::Rails::VERSION
  s.authors     = ["Andreas Marc Klingler"]
  s.email       = ["post@andreas-klingler.de"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rapidmail::Rails."
  s.description = "TODO: Description of Rapidmail::Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "sqlite3"
end
