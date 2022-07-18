module Api
  module V1
    module Common
      class FeatureToggle
        def self.call(feature_name:, **)
          Flipper.enabled?(feature_name)
        end
      end
    end
  end
end
