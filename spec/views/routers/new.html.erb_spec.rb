require 'rails_helper'

RSpec.describe "routers/new", type: :view do
  before(:each) do
    assign(:router, Router.new(
      name: "MyString",
      latitude: 1.5,
      longitude: 1.5
    ))
  end

  it "renders new router form" do
    render

    assert_select "form[action=?][method=?]", routers_path, "post" do

      assert_select "input[name=?]", "router[name]"

      assert_select "input[name=?]", "router[latitude]"

      assert_select "input[name=?]", "router[longitude]"
    end
  end
end
