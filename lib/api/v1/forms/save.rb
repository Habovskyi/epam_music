module Api
  module V1
    module Forms
      class Save
        def self.call(ctx:, key: :form, **)
          ctx[key].save
        end
      end
    end
  end
end
