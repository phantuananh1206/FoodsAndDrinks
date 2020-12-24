class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true,
            numericality: {only_integer: true,
                           greater_than: Settings.validation.number.zero}
  validates :price, presence: true,
            numericality: {greater_than: Settings.validation.number.zero}
  validate :product_present
  validate :order_present

  delegate :quantity, :name, to: :product, prefix: true

  private

  def product_present
    return if product

    errors.add(:product, t("carts.product_not_valid"))
  end

  def order_present
    return if order

    errors.add(:order, t("carts.order_not_valid"))
  end
end
