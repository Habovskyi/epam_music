module Api
  module V1
    class AboutsController < ApplicationController
      def index
        actual_about = ::About.order(:created_at).last

        return unless actual_about

        render json: Api::V1::About::DetailsSerializer.new(actual_about)
      end
    end
  end
end
