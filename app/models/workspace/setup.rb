class Workspace::Setup
  def initialize(user:)
    @user = user

    raise ArgumentError.new("You need to pass a user, eg. `user: …`") if !user
  end

  def save
    ActiveRecord::Base.transaction do
      create_workspace.tap do |workspace|
        workspace.add_member to: @user, role: :owner

        add_feature_access_to workspace
      end
    end
  end

  private

  def create_workspace = Workspace.create(name: "My Workspace")

  def add_feature_access_to(workspace) = workspace.create_access
end
