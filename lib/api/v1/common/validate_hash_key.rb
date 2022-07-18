module Api
  module V1
    module Common
      class ValidateHashKey
        def self.call(ctx:, hash: {}, key: nil, **)
          hash.key?(ctx[key])
        end
      end
    end
  end
end
