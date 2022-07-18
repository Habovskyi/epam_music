module Api
  module V1
    module Tokens
      class TokensGeneratorService < ApplicationService
        def initialize(user: nil)
          @user = user
        end

        def call
          tokens_response
        end

        private

        def tokens_response
          {
            access_token: AccessTokenGeneratorService.call(user: @user),
            refresh_token: RefreshTokenGeneratorService.call(user: @user),
            access_exp: ::User::ACCESS_TOKEN_EXPIRATION.from_now,
            refresh_exp: ::User::REFRESH_TOKEN_EXPIRATION.from_now
          }
        end
      end
    end
  end
end
