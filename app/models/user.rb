class User < ApplicationRecord
  has_secure_password
  has_many :short_urls, dependent: :destroy
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  PERMITTED_ATTRIBUTES = %i[name email password password_confirmation].freeze
end
  