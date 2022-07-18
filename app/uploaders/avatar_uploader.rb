# Shrine plugins and uploading logic
class AvatarUploader < ImageUploader
  DEFAULT_URL = Rails.root.join('assets/images/default_avatar.png').to_s.freeze

  Attacher.default_url do
    DEFAULT_URL
  end
end
