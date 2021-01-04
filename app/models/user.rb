class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze
  PW = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/.freeze

  attr_accessor :remember_token

  has_many_attached :images
  has_many :ratings, dependent: :destroy
  has_many :orders, dependent: :destroy

  enum role: {admin: 0, member: 1}

  validates :name, presence: true,
            length: {maximum: Settings.validation.user.name_max}
  validates :email, presence: true,
            length: {maximum: Settings.validation.user.email_max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: true
  validates :phone_number, format: {with: VALID_PHONE_REGEX}, presence: true
  validates :password, presence: true,
            length: {minimum: Settings.validation.user.pass_min},
            allow_nil: true
  validate :password_complexity

  has_secure_password

  before_save :downcase_email

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

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def password_complexity
    return if password.blank? || password =~ PW

    errors.add :password, I18n.t("pass_validate.validate_1")
    errors.add :password, I18n.t("pass_validate.validate_2")
    errors.add :password, I18n.t("pass_validate.validate_3")
    errors.add :password, I18n.t("pass_validate.validate_4")
  end

  private

  def downcase_email
    email.downcase!
  end
end
