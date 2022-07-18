module Api
  module V1
    module Users
      class CreateForm < BaseForm
        property :password
        property :password_confirmation, virtual: true

        with_options if: proc { model.password.present? } do |user|
          user.validates :password, length: { minimum: PASSWORD_MIN_LENGTH, maximum: PASSWORD_MAX_LENGTH }
          user.validates :password,
                         format: { with: /[a-z]+/, message: :at_least_one_letter }
          user.validates :password,
                         format: { with: /[A-Z]+/,
                                   message: :at_least_one_capital_letter }
          user.validates :password,
                         format: { with: /[0-9#{Regexp.quote(PASSWORD_SPECIAL_SYMBOLS)}]+/,
                                   message: :at_least_one_non_alphabetical }
          user.validates :password,
                         format: { without: /[^\w#{Regexp.quote(PASSWORD_SPECIAL_SYMBOLS)}]/,
                                   message: :allowed_symbols,
                                   symbols: PASSWORD_SPECIAL_SYMBOLS }
        end
      end
    end
  end
end
