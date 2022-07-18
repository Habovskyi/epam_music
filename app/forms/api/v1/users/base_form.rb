require 'reform/form/validation/unique_validator'

module Api
  module V1
    module Users
      class BaseForm < ApplicationForm
        include AvatarUploader::Attachment(:avatar)

        USERNAME_MIN_LENGTH = 5
        USERNAME_MAX_LENGTH = 20
        NAME_MIN_LENGTH = 2
        NAME_MAX_LENGTH = 20
        PASSWORD_MIN_LENGTH = 6
        PASSWORD_MAX_LENGTH = 20
        PASSWORD_SPECIAL_SYMBOLS = "\" !#$%&'()*+,-/\\:;<=>?@[]^_.`{|}~".freeze
        USERNAME_REGEXP = /\A(?![_.])(?!.*[_.]{2})[\w.]+(?<![_.])\z/
        NAME_REGEXP = /\A(?!['-])(?!.*['-]{2})[A-Za-z'-]+(?<!['-])\z/

        model :user

        property :username
        property :email
        property :first_name
        property :last_name

        validates :username, :email, presence: true
        validates :username, :email, unique: true
        validates :username, length: { in: USERNAME_MIN_LENGTH..USERNAME_MAX_LENGTH }, format: {
          with: USERNAME_REGEXP
        }, if: proc { username.present? }
        validates :email, format: {
          with: URI::MailTo::EMAIL_REGEXP
        }
        validates :first_name, :last_name, allow_nil: true, length: { in: NAME_MIN_LENGTH..NAME_MAX_LENGTH }, format: {
          with: NAME_REGEXP
        }
      end
    end
  end
end
