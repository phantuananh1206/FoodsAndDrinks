require 'rails_helper'

RSpec.describe "routers/edit", type: :view do
  before(:each) do
    @router = assign(:router, Router.create!(
      name: "MyString",
      latitude: 1.5,
      longitude: 1.5
    ))
  end

  it "renders the edit router form" do
    render

    assert_select "form[action=?][method=?]", router_path(@router), "post" do

      assert_select "input[name=?]", "router[name]"

      assert_select "input[name=?]", "router[latitude]"

      assert_select "input[name=?]", "router[longitude]"
    end
  end
end
