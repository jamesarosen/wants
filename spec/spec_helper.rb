$LOAD_PATH <<
  File.expand_path('../../lib', __FILE__) <<
  File.expand_path('..', __FILE__)

require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end
