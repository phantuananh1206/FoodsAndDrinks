class Product < ApplicationRecord
  belongs_to :category

  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many_attached :images
  has_many :orders, through: :order_details

  validates :name, presence: true
  validates :quantity, presence: true,
            numericality: {only_integer: true,
                           greater_than_or_equal_to:
                           Settings.validation.number.zero}
  validates :price, presence: true,
            numericality: {greater_than: Settings.validation.number.zero}
  scope :order_alphabet_name, ->{order name: :asc}
  scope :filter_product_by_name, ->(name){where("name like ?", "%#{name}%")}

  delegate :name, to: :category, prefix: true

  def avg_rating
    if ratings.present?
      ratings.average(:rating).round(1).to_f
    else
      0.0
    end
  end

  def rating_percentage
    if ratings.present?
      ratings.average(:rating).round(1).to_f * 100 / 5
    else
      0.0
    end
  end
end
