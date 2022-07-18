namespace :statistic do
  desc 'operate service statistics'

  task init: :environment do
    if Statistic.any?
      puts 'Statistig already has been generated!'
    else
      Api::V1::Statistics::GenerateService.call
    end
  end
end
