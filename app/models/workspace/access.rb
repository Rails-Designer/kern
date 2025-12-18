class Workspace::Access < RailsVault::Base
  vault_attribute :member_count, :integer, default: Config::Plans.default.dig(:features, :member_count)
end
