class Role < ApplicationRecord
  AVAILABLE = %w[administrator member owner]

  validates :name, presence: true, inclusion: {in: AVAILABLE}, uniqueness: true
end
