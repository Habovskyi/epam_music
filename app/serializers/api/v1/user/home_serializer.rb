module Api
  module V1
    module User
      class HomeSerializer
        include FastJsonapi::ObjectSerializer
        set_type :user
        attributes :username, :email, :first_name, :last_name, :playlists_created
      end
    end
  end
end
