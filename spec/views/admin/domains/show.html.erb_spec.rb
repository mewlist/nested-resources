require 'spec_helper'

describe "admin/domains/show.html.erb" do
  before(:each) do
    @domain = assign(:domain, stub_model(Domain,
      :name => "Name",
      :domain => "Domain",
      :wildcard => false,
      :status => "Status",
      :offline_message => "MyText"
    ))
    User.create(:name=>'test', :email=>'test@mydns.to', :password=>'test')
    @user = User.last
    @nested = NestedResources.new({:controller=>'domains', :user_id => @user.id}, :user)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Domain/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
