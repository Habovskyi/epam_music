module Api
  module V1
    module Common
      class Model
        include Servicable

        attr_reader :ctx, :methods, :parent, :options, :key

        # rubocop:disable Metrics/ParameterLists
        def initialize(ctx:, parent: nil, key: :model, methods: :new, options: {}, **)
          @ctx = ctx
          @key = key
          @methods = Array(methods)
          @parent = parent.is_a?(Symbol) ? ctx[parent] : parent
          @options = options
        end
        # rubocop:enable Metrics/ParameterLists

        def call
          ctx[key] = call_methods_on_parent
        end

        private

        def call_methods_on_parent
          query = methods[0...-1].inject(parent) { |scope, modifier| scope.public_send(modifier) }
          if options.is_a?(Hash)
            query.public_send(methods.last, **transformed_options)
          else
            query.public_send(methods.last, *exctract_value(options))
          end
        end

        def transformed_options
          @transformed_options ||= options.to_h do |property, property_key|
            value = exctract_value(property_key) || property_key
            [property, value]
          end
        end

        def exctract_value(path)
          ctx.dig(*Array(path))
        end
      end
    end
  end
end
