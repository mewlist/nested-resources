require 'action_controller'
require 'action_view'

module NestedResources
  require 'nested-resources/nested-resources'
  module NestedResourcesHelper
    def nested
      @nested
    end
  end
end

module ActionView::Helpers
  include NestedResources::NestedResourcesHelper
end

class ActionController::Base
  attr_reader :nested
  before_filter :nested_resources_filter

  def self.nested_resources(*resources)
    write_inheritable_attribute(:nested_resources, *resources)
  end

  def nested_resources_filter
    resources = self.class.read_inheritable_attribute(:nested_resources)
    return if resources.blank?
    @nested = NestedResources::NestedResources.new(params, resources)
  end

end

