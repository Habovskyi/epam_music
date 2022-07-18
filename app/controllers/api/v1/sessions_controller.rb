module Api
  module V1
    class SessionsController < ApiController
      REFRESH_TOKEN_GRAND_TYPE = 'refresh_token'.freeze

      before_action :forbid_authenticated

      def create
        response = if params_user.nil?
                     { status: :unauthorized }
                   else
                     data = Api::V1::Tokens::TokensGeneratorService.call(user: params_user)
                     { json: data }
                   end
        render response
      end

      def update
        response = if refresh_token_user.nil?
                     { status: :unauthorized }
                   else
                     revoke_token
                     data = Api::V1::Tokens::TokensGeneratorService.call(user: refresh_token_user)
                     { json: data }
                   end
        render response
      end

      private

      def revoke_token
        refresh_token.destroy
      end

      def refresh_token_user
        return unless refresh_token_params[:grand_type] == REFRESH_TOKEN_GRAND_TYPE && refresh_token

        @refresh_token_user ||= refresh_token.user
      end

      def refresh_token
        @refresh_token ||= WhitelistedToken.where('expiration >= ?', Time.zone.now)
                                           .find_by(crypted_token: refresh_token_params[:refresh_token])
      end

      def params_user
        @params_user ||= ::User.find_by(email: login_params[:email])&.authenticate(login_params[:password]) || nil
      end

      def login_params
        params.permit(:email, :password)
      end

      def refresh_token_params
        params.permit(:grand_type, :refresh_token)
      end
    end
  end
end
