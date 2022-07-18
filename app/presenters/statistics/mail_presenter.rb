module Statistics
  class MailPresenter
    POSITIVE_CLASS_NAME = 'positive'.freeze
    NEGATIVE_CLASS_NAME = 'negative'.freeze

    attr_reader :statistic, :statistic_to_compare, :plain_rows, :row_max_length

    def initialize(statistic, statistic_to_compare, time_period)
      @statistic = statistic.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)
      @statistic_to_compare = statistic_to_compare.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)
      @time_period = time_period
    end

    def formated_time_period
      @formated_time_period ||= @time_period.parts.map { |k, v| "#{v} #{k}" }.join
    end

    def compared_values
      @compared_values ||= @statistic.map.to_h { |k, v| [k, v - @statistic_to_compare[k]] }
    end

    def compared_value_div_class(key)
      compared_values[key].positive? == key.to_s.exclude?('deleted') ? POSITIVE_CLASS_NAME : NEGATIVE_CLASS_NAME
    end

    def format_int_value(value)
      value.positive? ? "+#{value}" : value
    end

    def generate_plain_text_data
      @plain_rows = []
      statistic.each do |key, value|
        @plain_rows << "#{I18n.t("action_mailer.statistic.headers.#{key}")} " \
                       "#{value} #{format_int_value(compared_values[key])}"
      end
      @row_max_length = @plain_rows.max_by(&:length).length
    end

    def horisontal_border
      '_' * row_max_length
    end

    def plain_row(row)
      "|#{row}#{' ' * (row_max_length - row.length)}|"
    end
  end
end
