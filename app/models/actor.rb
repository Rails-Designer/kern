class Actor < ApplicationRecord
  belongs_to :member
  belongs_to :role
end
