module Workspace::FeatureAccess
  extend ActiveSupport::Concern

  class PlanNotFoundError < StandardError; end

  included do
    vault :access
  end

  def add_access(product_id)
    plan = plans[product_id.to_sym]

    raise PlanNotFoundError, "Plan with product_id `#{product_id}` not found in `config/configurations/plans.yml`. Needs to be one of #{plans.keys.reject { it == :fallback }.join(", ")}." if plan.blank?

    access.update plan[:features]
    access
  end

  def reset_access!
    Workspace::Access.where(resource: self).destroy_all

    create_access
  end

  private

  def plans = Config::Plans
end
