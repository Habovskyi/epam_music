require 'shrine'

if Rails.env.development?
  require 'shrine/storage/file_system'
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
  }
elsif Rails.env.test?
  require 'shrine/storage/memory'
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  require 'shrine/storage/s3'
  s3_options = {
    access_key_id: Rails.application.credentials.s3.access_key_id,
    secret_access_key: Rails.application.credentials.s3.secret_access_key,
    region: Rails.application.credentials.s3.region,
    bucket: Rails.application.credentials.s3.bucket
  }
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'store', **s3_options)
  }
end

Shrine.plugin :activerecord
Shrine.plugin :backgrounding
Shrine.plugin :remove_attachment
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :derivatives, create_on_promote: true
Shrine.plugin :validation_helpers, default_messages: {
  max_size: ->(max) { I18n.t('activerecord.errors.image.too_big_size', max_size: max) },
  max_dimensions: ->(dims) { I18n.t('activerecord.errors.image.too_big_dim', dim: dims) },
  min_dimensions: ->(dims) { I18n.t('activerecord.errors.image.too_small_dim', dim: dims) },
  mime_type_inclusion: ->(list) { I18n.t('activerecord.errors.image.not_image', allowed_types: list) }
}
Shrine.plugin :store_dimensions, analyzer: :mini_magick

Shrine::Attacher.promote_block do
  ShrineWorkers::PromoteWorker.perform_async(self.class.name, record.class.name, record.id, name.to_s, file_data)
end

Shrine::Attacher.destroy_block do
  ShrineWorkers::DestroyWorker.perform_async(self.class.name, data)
end
