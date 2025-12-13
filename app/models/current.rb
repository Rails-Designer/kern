class Current < ActiveSupport::CurrentAttributes
  attribute :session

  delegate :user, to: :session, allow_nil: true
  delegate :workspace, to: :user

  def member = user.members.find_by(workspace: workspace)
end
