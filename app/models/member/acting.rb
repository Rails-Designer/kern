module Member::Acting
  extend ActiveSupport::Concern

  included do
    has_many :actors, dependent: :destroy
    has_many :roles, through: :actors
  end

  def has_role?(role_name)
    roles.any? { it.name.underscore.to_sym == role_name }
  end

  def add_role(role_name)
    role = Role.where(name: role_name.to_s).first_or_create

    raise "Invalid role" if !role

    actors.create role: role
  end

  def remove_role(role_name)
    role = Role.find_by(name: role_name.to_s)

    raise "Invalid role" if !role

    actors.where(role: role).destroy_all
  end
end
