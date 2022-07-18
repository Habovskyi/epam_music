module Api
  module V1
    module Tokens
      class AccessTokenGeneratorService < ApplicationService
        def initialize(**kwargs)
          @user = kwargs[:user]
        end

        def call
          generate_access_token
        end

        private

        def generate_access_token
          JsonWebToken.encode({ user_id: @user.id }, ::User::ACCESS_TOKEN_EXPIRATION.from_now)
        end
      end
    end
  end
end
