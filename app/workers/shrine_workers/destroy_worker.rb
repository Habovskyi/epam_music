module ShrineWorkers
  # destroy shrine attachments
  class DestroyWorker
    include Sidekiq::Job

    sidekiq_options queue: 'low'

    def perform(attacher_class, data)
      attacher_class = Object.const_get(attacher_class)

      attacher = attacher_class.from_data(data)
      attacher.destroy
    end
  end
end
