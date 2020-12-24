class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, presence: true
  scope :orders_alphabet_category, ->{order :name}
end
