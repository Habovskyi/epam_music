module ShrineWorkers
  # promote shrine attachments
  class PromoteWorker
    include Sidekiq::Job

    sidekiq_options queue: 'low'

    # rubocop:disable  Metrics/ParameterLists
    def perform(attacher_class, record_class, record_id, name, file_data)
      attacher_class = Object.const_get(attacher_class)
      record         = Object.const_get(record_class).find(record_id) # if using Active Record
      attacher = attacher_class.retrieve(model: record, name:, file: file_data)
      attacher.atomic_promote
    rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
      # attachment has changed or the record has been deleted, nothing to do
    end
    # rubocop:enable  Metrics/ParameterLists
  end
end
