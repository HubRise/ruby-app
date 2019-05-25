$LOAD_PATH.push File.expand_path("lib", __dir__)

require "hubrise_app/version"

Gem::Specification.new do |spec|
  spec.name        = "hubrise_app"
  spec.version     = HubriseApp::VERSION
  spec.authors     = [
    "Antoine Monnier",
    "Nick Save"
  ]
  spec.homepage    = "https://hubrise.com"
  spec.summary     = "Rails Engine to easily bootstrap Hubrise Thirdparty Application"
  spec.description = "Rails Engine to easily bootstrap Hubrise Thirdparty Application"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"
  spec.add_development_dependency "mysql2"
end
