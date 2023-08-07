require_relative "lib/signalman/version"

Gem::Specification.new do |spec|
  spec.name = "signalman"
  spec.version = Signalman::VERSION
  spec.authors = ["Chris Oliver"]
  spec.email = ["excid3@gmail.com"]
  spec.homepage = "https://github.com/excid3/signalman"
  spec.summary = "Development tools for Ruby on Rails"
  spec.description = "Development tools for Ruby on Rails"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/excid3/signalman"
  spec.metadata["changelog_uri"] = "https://github.com/excid3/signalman/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"
end
