module Api
  module V1
    module About
      class DetailsSerializer < ApplicationSerializer
        set_type :about

        attributes :body
      end
    end
  end
end
