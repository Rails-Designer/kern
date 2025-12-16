class User < ApplicationRecord
  include WorkspaceMember

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: -> { it.strip.downcase }

  validates_format_of :email_address, with: URI::MailTo::EMAIL_REGEXP

  validates :password, length: 8..128

  encrypts :email, deterministic: true, downcase: true
end
