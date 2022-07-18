module Api
  module V1
    module Users
      class Destroy < ApplicationAction
        logic do
          step :inactivate
        end

        def inactivate(model:, **)
          model.update(active: false)
        end
      end
    end
  end
end
