class Member::Setup
  def initialize(workspace:, user:, role: "member")
    @workspace = workspace
    @user = user
    @role = role&.to_sym
  end

  def save
    ActiveRecord::Base.transaction do
      create_member.tap do |member|
        add_roles_to member

        mark_workspace_current
      end
    end
  end

  private

  def create_member = Member.create(workspace: @workspace, user: @user)

  def add_roles_to(member)
    roles.each do |role_name|
      member.actors.create role: Role.where(name: role_name).first_or_create
    end
  end

  def mark_workspace_current = @user.update!(workspace: @workspace)

  def roles
    {
      administrator: %w[administrator],
      member: %w[member],
      owner: %w[administrator member owner]
    }[@role] || []
  end
end
