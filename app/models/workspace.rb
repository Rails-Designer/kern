class Workspace < ApplicationRecord
  include Sluggable

  include Billable
  include Members

  validates :name, presence: true
end
