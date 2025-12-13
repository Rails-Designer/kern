class Signup < ApplicationForm
  attribute :email_address, :string
  attribute :password, :string

  normalizes :email_address, with: -> { it.strip.downcase }

  validates :email_address, :password, presence: true
  validates_format_of :email_address, with: URI::MailTo::EMAIL_REGEXP
  validate :email_is_unique?

  validates :password, length: 8..128

  def save
    if valid?
      transaction do
        @user = create_user.tap { it.setup_workspace.save }.tap do |user|
          # Add other actions here, e.g. `send_welcome_email_to user`
        end
      end
    end
  end

  attr_reader :user

  private

  def create_user = User.create!(email_address: email_address, password: password)

  # def send_welcome_email_to(user)
  # Logic to send email
  # end

  def email_is_unique?
    if User.exists? email_address: email_address
      errors.add :email_address, "has already been taken"
    end
  end
end
