class AssociationExistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @attribute = attribute
    return if model.where(id: value).exists?

    record.errors.add(attribute, :not_exist)
  end

  private

  def model
    Object.const_get(model_name)
  end

  def model_name
    @attribute.to_s.gsub('_id', '').capitalize
  end
end
