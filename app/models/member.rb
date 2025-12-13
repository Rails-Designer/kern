class Member < ApplicationRecord
  include Sluggable

  include Acting

  belongs_to :user
  belongs_to :workspace

  delegate :email_address, to: :user
end
