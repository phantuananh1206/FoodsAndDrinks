require "rails_helper"

RSpec.describe Voucher, type: :model do
  describe "Associations" do
    it { should have_many(:orders) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:discount) }
    it { should validate_presence_of(:condition) }
  end
end
