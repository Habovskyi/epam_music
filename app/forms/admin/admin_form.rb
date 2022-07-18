module Admin
  class AdminForm < Reform::Form
    def attributes=(attributes)
      validate(attributes) unless attributes.empty?
    end

    def save
      return unless valid?

      super
    end
  end
end
