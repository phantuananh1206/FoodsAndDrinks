require "rails_helper"
require "factories/users"

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build :user }

  describe "Associations" do
    it { should have_many_attached(:images) }
    it { should have_many(:ratings) }
    it { should have_many(:orders) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Settings.rspec.validation.user.name_max) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(Settings.rspec.validation.user.email_max) }
    it { should allow_value(Faker::Internet.email).for(:email) }
    it { should allow_value(Faker::Number.leading_zero_number(digits: 10)).for(:phone_number) }
    it { should allow_value(nil).for(:phone_number) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(Settings.rspec.validation.user.pass_min) }
  end

  describe "Method downcase email" do
    it "downcase email" do
      expect(user.email.downcase!).to eq("abc123@gmail.com")
    end
  end
end
