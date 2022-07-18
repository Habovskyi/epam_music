module Api
  module V1
    module Forms
      class Initialize
        # rubocop:disable Metrics/ParameterLists
        def self.call(ctx:, constant:, form_key: :form, model_key: :model, **)
          ctx[form_key] = constant.new(ctx[model_key])
        end
        # rubocop:enable Metrics/ParameterLists
      end
    end
  end
end
