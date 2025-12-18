class Workspace < ApplicationRecord
  include Sluggable

  include Billable
  include FeatureAccess
  include Members

  validates :name, presence: true
end
