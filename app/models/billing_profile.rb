class BillingProfile < ApplicationRecord
  include Sluggable

  belongs_to :workspace

  has_many :subscriptions, dependent: :destroy
end
