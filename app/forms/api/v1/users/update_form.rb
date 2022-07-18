module Api
  module V1
    module Users
      class UpdateForm < BaseForm
        include AvatarUploader::Attachment(:avatar)

        property :avatar_data
        property :avatar, virtual: true

        validate :valid_attachement

        def save
          super
          model.avatar_derivatives! unless avatar.nil?
          true
        end

        private

        def valid_attachement
          avatar_attacher.assign(avatar)
          return true if avatar_attacher.errors.empty?

          avatar_attacher.errors.each do |error|
            errors.add(:avatar, :invalid, message: error)
          end
        end
      end
    end
  end
end
