require "rails_helper"
require "factories/orders"
require "factories/order_details"

RSpec.describe Order, type: :model do
  let(:order) { FactoryBot.build :order }
  let(:order_detail) { FactoryBot.build :order_detail }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:voucher).optional }
    it { should have_many(:order_details) }
    it { should have_many(:products).through(:order_details) }
  end

  describe "Validations" do
    it { should validate_presence_of(:phone_number) }
    it { should allow_value(Faker::Number.leading_zero_number(10)).for(:phone_number) }
    it { should validate_presence_of(:address) }
  end

  describe "Method order" do
    it "Cancel order" do
      expect(order.cancel).to be true
    end
    it "Update quantity product" do
      expect(order_detail.product.quantity).to be >= 0
    end
  end
end
