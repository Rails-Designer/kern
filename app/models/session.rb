class Session < ApplicationRecord
  belongs_to :user

  encrypts :user_agent, :ip
end
