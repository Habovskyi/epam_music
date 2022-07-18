class LogoUploader < ImageUploader
  DEFAULT_URL = Rails.root.join('assets/images/default_playlist.jpg').to_s.freeze

  Attacher.default_url do
    DEFAULT_URL
  end
end
