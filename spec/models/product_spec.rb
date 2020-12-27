require "rails_helper"
require "factories/products"
require "factories/ratings"

RSpec.describe Product, type: :model do
  let(:product) { FactoryBot.build :product }
  let(:rating) { FactoryBot.build :rating }

  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:order_details) }
    it { should have_many(:ratings)}
    it { should have_many(:orders).through(:order_details) }
    it { should have_many_attached(:images) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:price) }
  end

  describe "Scope fitler product by name" do
    it "filter product with no input" do
      expect(Product.filter_product_by_name("")).to be_truthy
    end
    it "filter product with valid input" do
      expect(Product.filter_product_by_name("Food")).to be_truthy
    end
    it "filter product with invalid input" do
      expect(Product.filter_product_by_name("123123")).to match_array([])
    end
  end


  describe "Method rating" do
    it "Average raiting with rating not present" do
      expect(product.avg_rating).to eq(0.0)
    end
    it "Percent raiting with rating not present" do
      expect(product.rating_percentage).to eq(0.0)
    end
    it "Average raiting with rating present" do
      expect(rating.product.avg_rating).to be >=(0.0)
    end
    it "Percent raiting with rating present" do
      expect(rating.product.rating_percentage).to be >=(0.0)
    end
  end
end
