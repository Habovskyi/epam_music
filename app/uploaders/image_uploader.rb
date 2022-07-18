class ImageUploader < Shrine
  plugin :default_url
  plugin :remove_attachment

  ALLOWED_MIME_TYPES = %w[image/jpeg image/png].freeze
  MAX_SIZE = 5 * 1024 * 1024
  MAX_DIM_SIZE = 4098
  MIN_DIM_SIZE = 100
  DEFAULT_URL = Rails.root.join('assets/images/no_image.png').to_s.freeze
  THUMBNAILS_SIZES = {
    large: [1000, 1000],
    small: [100, 100]
  }.freeze

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    THUMBNAILS_SIZES.transform_values do |value|
      magick.resize_to_fill!(*value)
    end
  end

  Attacher.validate do
    validate_mime_type ALLOWED_MIME_TYPES
    validate_max_size MAX_SIZE
    validate_dimensions [MIN_DIM_SIZE..MAX_DIM_SIZE] * 2
  end
end
