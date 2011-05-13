require 'action_controller'
require 'action_view'

module NestedResources
  require 'nested-resources/nested-resources'
  module NestedResourcesHelper
    def nested(obj = nil)
      if obj.is_a?(Class)
        @nested.instance(obj)
      elsif obj
        @nested.path(obj)
      else
        @nested
      end
    end

    def nested?(obj)
      @nested.exists?(obj)
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
    @nested = NestedResources::NestedResources.new(params, resources)
  end

end

