require 'action_controller'
require 'action_view'

module NestedResources
  require 'nested-resources/nested-resources'
  module NestedResourcesHelper
    def nested(obj = nil)
      if obj.is_a?(Class)
        @nested_resources.instance(obj)
      elsif obj.is_a?(String)
        @nested_resources.path(obj)
      elsif obj
        @nested_resources.resources(obj)
      else
        @nested_resources
      end
    end

    def nested?(obj)
      @nested_resources.exists?(obj)
    end
  end
end

module ActionView::Helpers
  include NestedResources::NestedResourcesHelper
end

class ActionController::Base
  include NestedResources::NestedResourcesHelper
  before_filter :nested_resources_filter

  def self.nested_resources(*resources)
    write_inheritable_attribute(:nested_resources, *resources)
  end

  def nested_resources_filter
    resources = self.class.read_inheritable_attribute(:nested_resources)
    return if resources.blank?
    @nested_resources = NestedResources::NestedResources.new(params, resources)
  end

end

