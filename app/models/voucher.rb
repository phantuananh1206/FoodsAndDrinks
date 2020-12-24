class Voucher < ApplicationRecord
  has_many :orders, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :discount, presence: true
  validates :condition, presence: true
end
