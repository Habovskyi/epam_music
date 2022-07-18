module Api
  module V1
    module Common
      class Paginate
        include Pagy::Backend
        include Servicable

        attr_reader :page, :items

        # rubocop:disable  Metrics/ParameterLists
        def initialize(ctx:, per_page:, options:, model: :model, **)
          @ctx = ctx
          @items = per_page
          @model = model
          @page = exctract_value(options) || 1
        end
        # rubocop:enable Metrics/ParameterLists

        def call
          _, @ctx[@model] = pagy(@ctx[@model], items:, page:)
        end

        private

        def exctract_value(options)
          @ctx.dig(*Array(options))
        end
      end
    end
  end
end
