module Api
  module V1
    module Playlists
      class BaseForm < ApplicationForm
        include LogoUploader::Attachment(:logo)

        TITLE_MIN_LENGTH = 2
        TITLE_MAX_LENGTH = 20
        TITLE_REGEXP = %r{\A[a-zA-Z0-9& /]+\z}
        DESCRIPTION_MAX_LENGTH = 100

        model :playlist

        property :logo_data
        property :user
        property :logo, virtual: true
        property :title
        property :description
        property :visibility

        validates :user, presence: true
        validates :title, presence: true, length: { in: TITLE_MIN_LENGTH..TITLE_MAX_LENGTH }, format: {
          with: TITLE_REGEXP
        }
        validates :description, length: { maximum: DESCRIPTION_MAX_LENGTH }
        validates :visibility, allow_nil: true,
                               inclusion: { in: ::Playlist.visibilities.keys + ::Playlist.visibilities.values }
        validate :valid_attachement
        validate :visibility_change

        def save
          super
          model.logo_derivatives! unless logo.nil?
        end

        private

        def valid_attachement
          logo_attacher.assign(logo)
          return true if logo_attacher.errors.empty?

          logo_attacher.errors.each do |error|
            errors.add(:logo, :invalid, message: error)
          end
        end

        def visibility_change
          errors.add(:visibility, :cannot_be_modified) if model.shared? && visibility != 'shared'
        end
      end
    end
  end
end
