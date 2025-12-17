module BillingProfile
  class Subscription < ApplicationRecord
    include Sluggable

    belongs_to :billing_profile

    enum :status, %w[incomplete active trialing canceled incomplete_expired past_due unpaid free].index_by(&:itself), default: "incomplete"

    store_attribute :metadata, :interval, :string
    store_attribute :metadata, :product_id, :string
    store_attribute :metadata, :price_id, :string
    store_attribute :metadata, :quantity, :integer, default: 0

    validates :quantity, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  end
end
