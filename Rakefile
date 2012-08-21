begin
  require 'bundler/setup'
  Bundler.require(:test)
  require 'rake'
  require 'rake/clean'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  CLEAN.include('./*.gem')

  CLOBBER.include('./.rvmrc')
rescue LoadError
  task :spec do
    abort 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

task :default => :spec
