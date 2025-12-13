module User::WorkspaceMember
  extend ActiveSupport::Concern

  included do
    has_many :members, dependent: :destroy
    has_many :workspaces, through: :members

    belongs_to :workspace, class_name: "Workspace", foreign_key: :current_workspace_id, optional: true
  end

  def setup_workspace = Workspace::Setup.new(user: self)
end
