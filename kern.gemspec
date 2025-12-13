require_relative "lib/kern/version"

Gem::Specification.new do |spec|
  spec.name = "kern"
  spec.version = Kern::VERSION
  spec.authors = ["Rails Designer"]
  spec.email = "devs@railsdeigner.com"

  spec.summary = "Rails engine with auth, billing, and common components for SaaS apps"
  spec.description = "A Rails engine that handles the SaaS essentials: authentication, team invitations, subscription/billing, and common partials. Skip the boilerplate and start shipping the actual product. Launch faster."
  spec.homepage = "https://saas.railsdesigner.com/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/kern/"

  spec.files = Dir["{bin,app,db,config,lib}/**/*", "Rakefile", "README.md", "kern.gemspec", "Gemfile", "Gemfile.lock"]

  spec.required_ruby_version = ">= 3.4.0"

  spec.add_dependency "rails", ">= 8.0.0"
end
