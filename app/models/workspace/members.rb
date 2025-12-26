class Workspace
  module Members
    extend ActiveSupport::Concern

    included do
      has_many :members, dependent: :destroy
      has_many :users, through: :members

      after_destroy_commit :purge_orphaned_users!
    end

    def add_member(to:, role: nil) = Member::Setup.new(workspace: self, user: to, role: role).save

    private

    def purge_orphaned_users! = User.left_joins(:members).where(members: { id: nil }).destroy_all
  end
end
