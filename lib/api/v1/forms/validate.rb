module Api
  module V1
    module Forms
      class Validate
        # rubocop:disable Metrics/ParameterLists
        def self.call(ctx:, error_store:, params_key: :params, form_key: :form, **)
          ctx[form_key].validate(ctx[params_key])
          ctx[form_key].errors.each do |error|
            error_store.add_error(error.attribute, error.message)
          end
          error_store.errors.empty?
        end
        # rubocop:enable Metrics/ParameterLists
      end
    end
  end
end
