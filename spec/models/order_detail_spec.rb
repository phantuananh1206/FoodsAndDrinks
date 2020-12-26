require "rails_helper"
require "factories/orders"

RSpec.describe OrderDetail, type: :model do
  let(:order) { FactoryBot.build :order }

  describe "Associations" do
    it { should belong_to(:order).required }
    it { should belong_to(:product).required }
  end

  describe "Validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:price) }
  end

  describe "Method order details" do
    it "Check order present" do
      expect(order).to be_truthy
    end
  end
end
