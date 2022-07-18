module ServiceWorkers
  class StatisticWorker
    include Sidekiq::Job

    sidekiq_options queue: 'default'

    def perform
      @time_period = 24.hours
      build_statistic
      delete_unactive_records
      send_statistic_mail
    end

    private

    def build_statistic
      @statistic, @statistic_to_compare = Api::V1::Statistics::GenerateService.call(@time_period)
    end

    def delete_unactive_records
      ActiveRecord::Base.transaction do
        ::User.where(active: false).each(&:destroy!)
        ::Playlist.where.not(deleted_at: nil).each(&:destroy!)
      end
    end

    def send_statistic_mail
      StatisticMailer.statistic_mail(@statistic, @statistic_to_compare, @time_period).deliver_later
    end
  end
end
