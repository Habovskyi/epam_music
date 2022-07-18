module Api
  module V1
    module Author
      class InfoSerializer < ApplicationSerializer
        set_type :author
        attributes :nickname
      end
    end
  end
end
