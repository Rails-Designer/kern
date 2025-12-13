class Workspace < ApplicationRecord
  include Sluggable

  include Members

  validates :name, presence: true
end
