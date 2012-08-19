Gem::Specification.new do |gem|
  gem.version = '0.0.1'
  gem.name = 'wants'
  gem.files = Dir["lib/**/*"] + %w(README.md)
  gem.summary = "HTTP Accept header support"
  gem.description = "Parse and query the HTTP Accept header"
  gem.email = "james.a.rosen@gmail.com"
  gem.homepage = "http://github.com/jamesarosen/wants"
  gem.authors = ["James A. Rosen"]
  gem.test_files = Dir["spec/**/*"]
  gem.require_paths = %w{ lib }
  gem.has_rdoc = 'false'
  current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
  gem.specification_version = 2

  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
