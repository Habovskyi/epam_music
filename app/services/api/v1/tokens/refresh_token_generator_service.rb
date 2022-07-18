module Api
  module V1
    module Tokens
      class RefreshTokenGeneratorService < ApplicationService
        def initialize(**kwargs)
          @user = kwargs[:user]
        end

        def call
          generate_refresh_token
        end

        private

        def generate_refresh_token
          token = JsonWebToken.encode({ email: @user.email }, ::User::REFRESH_TOKEN_EXPIRATION.from_now)
          @user.whitelisted_tokens.create!(crypted_token: token, expiration: ::User::REFRESH_TOKEN_EXPIRATION.from_now)
          token
        end
      end
    end
  end
end
