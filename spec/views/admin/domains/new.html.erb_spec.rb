require 'spec_helper'

describe "admin/domains/new.html.erb" do
  before(:each) do
    assign(:domain, stub_model(Domain,
      :name => "MyString",
      :domain => "MyString",
      :wildcard => false,
      :status => "MyString",
      :offline_message => "MyText"
    ).as_new_record)
    User.create(:name=>'test', :email=>'test@mydns.to', :password=>'test')
    @user = User.last
    @nested = NestedResources.new({:controller=>'domains', :user_id => @user.id}, :user)
  end

  it "renders new domain form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_domains_path, :method => "post" do
      assert_select "input#domain_name", :name => "domain[name]"
      assert_select "input#domain_domain", :name => "domain[domain]"
      assert_select "input#domain_wildcard", :name => "domain[wildcard]"
      assert_select "input#domain_status", :name => "domain[status]"
      assert_select "textarea#domain_offline_message", :name => "domain[offline_message]"
    end
  end
end