$LOAD_PATH.push File.expand_path("lib", __dir__)

require "hubrise_app/version"

Gem::Specification.new do |spec|
  spec.name        = "hubrise_app"
  spec.version     = HubriseApp::VERSION
  spec.authors     = [
    "Antoine Monnier",
    "Nick Save"
  ]
  spec.homepage    = "https://github.com/HubRise/ruby-app"
  spec.summary     = "Rails engine to bootstrap a HubRise-based application"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "hubrise_client", "~> 2.0.0"
  spec.add_dependency "rails", "> 5.2.2"
end
