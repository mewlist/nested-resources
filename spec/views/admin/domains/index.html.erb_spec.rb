require 'spec_helper'

describe "admin/domains/index.html.erb" do
  before(:each) do
    assign(:domains, [
      stub_model(Domain,
        :name => "Name",
        :domain => "Domain",
        :wildcard => false,
        :status => "Status",
        :offline_message => "MyText"
      ),
      stub_model(Domain,
        :name => "Name",
        :domain => "Domain",
        :wildcard => false,
        :status => "Status",
        :offline_message => "MyText"
      )
    ])
    User.create(:name=>'test', :email=>'test@mydns.to', :password=>'test')
    @user = User.last
    @nested = NestedResources.new({:controller=>'domains', :user_id => @user.id}, :user)
  end

  it "renders a list of domains" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Domain".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
