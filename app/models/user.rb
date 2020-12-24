class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze

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
  validates :phone_number, format: {with: VALID_PHONE_REGEX}, allow_nil: true
  validates :password, presence: true,
            length: {minimum: Settings.validation.user.pass_min},
            allow_nil: true
  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
