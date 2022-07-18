module Api
  module V1
    module Album
      class InfoSerializer < ApplicationSerializer
        set_type :album
        attributes :title
      end
    end
  end
end
