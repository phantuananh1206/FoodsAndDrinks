class Order < ApplicationRecord
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  belongs_to :user
  belongs_to :voucher, optional: true

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, confirmed: 1, accepted: 2, refused: 3,
                canceled: 4, shipping: 5, delivered: 6}

  validates :phone_number, presence: true,
            format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true

  extend ActiveModel::Callbacks
  define_model_callbacks :cancel, only: :after
  after_cancel :update_quantity_product_cancel
  after_create :update_quantity_product

  scope :by_created_at, ->{order(delivery_time: :desc)}
  scope :orderby_od_create, ->{order(created_at: :desc)}

  def cancel
    run_callbacks :cancel do
      canceled!
    end
  end

  def update_quantity_product_cancel
    order_details.map do |od|
      @product = od.product
      @product.update!(quantity: (@product.quantity + od.quantity))
    end
  end

  def update_quantity_product
    order_details.map do |od|
      @product = od.product
      @product.update!(quantity: (@product.quantity - od.quantity))
    end
  end
end
