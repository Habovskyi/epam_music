module Api
  module V1
    module Responses
      class Status
        def self.call(ctx:, value:, status_key: :status, **)
          ctx[status_key] = value
        end
      end
    end
  end
end
