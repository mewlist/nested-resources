require 'rubygems'
require 'active_record'
require 'action_controller'
require 'nested-resources'

class Parent 
end
class Child
end
class Model
end

class Controller < ActionController::Base
  nested_resources [:parent, :model]
end

RSpec.configure do |config|
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end
