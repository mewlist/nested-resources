require 'spec_helper'

describe NestedResources::NestedResources do

  describe "Basic nested resources" do
    before do
      @nested = NestedResources::NestedResources.new({:controller=>'models', :parent_id=>1}, :parent)
      @parent = Parent.new
      @model  = Model.new
    end

    it "should create with params" do
      @nested.should_not be(nil)
    end
    
    it "generate nested path" do
      @nested.path("models/5").should eq("parents/1/models/5")
    end
    
    it "generate namespaced nested path" do
      @nested.path("admin/models/5").should eq("admin/parents/1/models/5")
    end
    
    it "generate nested resources" do
      Parent.stub(:find).with(1) { @parent }
      @nested.resource(@model).should eq([@parent,@model])
    end
    
    it "generate namespaced nested resources" do
      Parent.stub(:find).with(1) { @parent }
      @nested.resource([:admin, @model]).should eq([:admin,@parent,@model])
    end
    
  end

  describe "Deeply nested resources" do
    before do
      @nested = NestedResources::NestedResources.new({:controller=>'models', :child_id=>2, :parent_id=>1}, :parent,:child)
      @parent = Parent.new
      @child  = Child.new
      @model  = Model.new
    end

    it "should create with params" do
      @nested.should_not be(nil)
    end
    
    it "generate nested path" do
      @nested.path("models/5").should eq("parents/1/children/2/models/5")
    end
    
    it "generate namespaced nested path" do
      @nested.path("admin/models/5").should eq("admin/parents/1/children/2/models/5")
    end
    
    it "generate nested resources" do
      Parent.stub(:find).with(1) { @parent }
      Child.stub(:find).with(2) { @child }
      @nested.resource(@model).should eq([@parent,@child,@model])
    end
    
    it "generate namespaced nested resources" do
      Parent.stub(:find).with(1) { @parent }
      Child.stub(:find).with(2) { @child }
      @nested.resource([:admin, @model]).should eq([:admin,@parent,@child,@model])
    end
    
  end

  describe "Resources decleared :as" do
    before do
      @nested = NestedResources::NestedResources.new({:controller=>'models', :child_id=>2, :father_id=>1}, {:parent => :father_id}, :child)
      @parent = Parent.new
      @child  = Child.new
      @model  = Model.new
    end

    it "should create with params" do
      @nested.should_not be(nil)
    end
    
    it "generate nested path" do
      @nested.path("models/5").should eq("parents/1/children/2/models/5")
    end
    
    it "generate namespaced nested path" do
      @nested.path("admin/models/5").should eq("admin/parents/1/children/2/models/5")
    end
    
    it "generate nested resources" do
      Parent.stub(:find).with(1) { @parent }
      Child.stub(:find).with(2) { @child }
      @nested.resource(@model).should eq([@parent,@child,@model])
    end
    
    it "generate namespaced nested resources" do
      Parent.stub(:find).with(1) { @parent }
      Child.stub(:find).with(2) { @child }
      @nested.resource([:admin, @model]).should eq([:admin,@parent,@child,@model])
    end
    
  end

end
