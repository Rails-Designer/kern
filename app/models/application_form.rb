class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Attributes::Normalization
  include ActiveModel::Validations::Callbacks

  def model_name
    ActiveModel::Name.new(self, nil, self.class.name.delete_suffix("Form"))
  end

  def transaction(&block) = ActiveRecord::Base.transaction(&block)
end
