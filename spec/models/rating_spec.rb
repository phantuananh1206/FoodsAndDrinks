require "rails_helper"

RSpec.describe Rating, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe "Validations" do
    it { should validate_presence_of(:rating) }
  end
end
