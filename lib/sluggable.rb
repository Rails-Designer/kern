# Usage
#
# Migration:
# add_column :<table_name>, :slug, null: false
# add_index :<table_name>, :slug, unique: true, # or:
# add_index :<table_name>, [:slug, :workspace_id], unique: true
#
# In app/models/<name>.rb
# include Sluggable
#
# In app/controller/model_name_plural_controller.rb
# `<model_name>.sluggble.find(params[:id])`
#
module Sluggable
  extend ActiveSupport::Concern

  class_methods do
    def create_slug(from:)
      @slug_source = from
    end
  end

  included do
    before_create :set_slug

    scope :sluggable, -> { Sluggable::Finder.new(self) }
  end

  def to_key = [slug]

  def to_param = slug

  private

  def set_slug
    return if slug

    slug = if slug_source && send(slug_source).present?
      send(slug_source).parameterize
    else
      random_slug
    end

    self.slug = slug
  end

  def random_slug
    loop do
      slug = SecureRandom.hex(4)

      return slug unless self.class.name.constantize.where(slug: slug).exists?
    end
  end

  def slug_source = self.class.instance_variable_get(:@slug_source)
end

class Sluggable::Finder
  def initialize(scope)
    @scope = scope
  end

  def find(slug) = @scope.find_by(slug: slug)

  def find!(slug) = @scope.find_by!(slug: slug)
end
