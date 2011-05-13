require 'spec_helper'

describe "In Controller" do

  describe "generate path" do
    controller = Controller.new
    @model = Model.new
    @parent= Parent.new

    it "should return nested path" do
      controller.params = {:controller=>"child", :action=>"index", :model_id => 1}
      controller.nested_resources_filter
      controller.nested("child/path/to").should eq("models/1/child/path/to")
    end
    
    it "should return path direct" do
      controller.params = {:controller=>"child", :action=>"index"}
      controller.nested_resources_filter
      controller.nested("child/path/to").should eq("child/path/to")
    end
    
    it "should return deep nested path" do
      controller.params = {:controller=>"child", :action=>"index", :model_id => 1, :parent_id => 143 }
      controller.nested_resources_filter
      controller.nested("child/path/to").should eq("parents/143/models/1/child/path/to")
    end

    it "should return merged objects " do
      Parent.stub(:find).with(1) { @parent }
      controller.params = {:controller=>"child", :action=>"index", :parent_id => 1}
      controller.nested_resources_filter
      controller.nested.resources(@model).should eq([Parent.find(1), @model])
      controller.nested.resources([:admin, @model]).should eq([:admin, Parent.find(1), @model])
    end

    it "should return objects direct" do
      controller.params = {:controller=>"child", :action=>"index"}
      controller.nested_resources_filter
      controller.nested.resources(@model).should eq([@model])
      controller.nested.resources([:admin, @model]).should eq([:admin, @model])
    end

  end

end
