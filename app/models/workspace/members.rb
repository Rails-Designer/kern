class Workspace
  module Members
    extend ActiveSupport::Concern

    included do
      has_many :members, dependent: :destroy
      has_many :users, through: :members
    end

    def add_member(to:, role: nil) = Member::Setup.new(workspace: self, user: to, role: role).save
  end
end
