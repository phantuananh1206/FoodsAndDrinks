require 'rails_helper'

RSpec.describe "routers/index", type: :view do
  before(:each) do
    assign(:routers, [
      Router.create!(
        name: "Name",
        latitude: 2.5,
        longitude: 3.5
      ),
      Router.create!(
        name: "Name",
        latitude: 2.5,
        longitude: 3.5
      )
    ])
  end

  it "renders a list of routers" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 2
    assert_select "tr>td", text: 3.5.to_s, count: 2
  end
end
