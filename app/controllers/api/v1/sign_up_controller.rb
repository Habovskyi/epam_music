module Api
  module V1
    class SignUpController < ApiController
      before_action :forbid_authenticated

      def index
        user_form = ::Api::V1::Users::CreateForm.new(::User.new)
        response = if user_form.validate(user_params)
                     user_form.save
                     { json: Api::V1::Tokens::TokensGeneratorService.call(user: user_form.model), status: :ok }
                   else
                     { json: { errors: user_form.errors }, status: :bad_request }
                   end
        render response
      end

      private

      def user_params
        params.permit(:username, :email, :password, :password_confirmation, :first_name,
                      :last_name).with_defaults(password_confirmation: '')
      end
    end
  end
end
