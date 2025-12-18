class Workspace::Access < RailsVault::Base
  vault_attribute :member_count, :integer, default: Config::Plans.dig(:default, :features, :member_count)
end
