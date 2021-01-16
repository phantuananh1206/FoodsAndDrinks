class Order < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

  attr_accessor :confirmation_token

  belongs_to :user
  belongs_to :voucher, optional: true

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {waiting: 0, confirmed: 1, accepted: 2, refused: 3,
                canceled: 4, shipping: 5, delivered: 6}

  validates :name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true,
            format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true
  validates :delivery_time, presence: true

  extend ActiveModel::Callbacks
  define_model_callbacks :cancel, only: :after
  define_model_callbacks :refuse, only: :after
  after_cancel :update_quantity_product_cancel
  after_create :update_quantity_product
  after_refuse :update_quantity_product_cancel

  scope :by_created_at, ->{order(delivery_time: :desc)}
  scope :orderby_od_create, ->{order(created_at: :desc)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end

      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def cancel
    run_callbacks :cancel do
      canceled!
    end
  end

  def refuse
    run_callbacks :refuse do
      refused!
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

  def send_confirmation_email
    OrderMailer.order_confirmation(@order, @user).deliver_now
  end

  def confirm
    update_columns(confirmed_at: Time.zone.now,
                   status: 1)
  end

  def total_price_order order
    @total = 0
    @total = order_details.reduce(0) do |sum, o|
      sum + o.quantity * o.price
    end
    return @total - order.voucher.discount if order.voucher

    @total
  end

  def total_price
    order_details.reduce(0) do |sum, order_detail|
      if order_detail.valid?
        sum + (order_detail.quantity * order_detail.price)
      else
        0
      end
    end
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
s
    BCrypt::Password.new(digest).is_password? token
  end

  def order_confirm_expired?
    confirm_sent_at < Settings.mail.expired.hours.ago
    Order.transaction do
      order.cancel
    end
  end

  def create_confirmation_digest
    self.confirmation_token = Order.new_token
    update_columns(confirmation_digest: Order.digest(confirmation_token),
                   confirm_sent_at: Time.zone.now)
  end
end
