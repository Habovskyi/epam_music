RSpec.describe 'api/v1/abouts', type: :request do
  path '/api/v1/abouts' do
    get('actually about') do
      consumes 'application/json'
      produces 'application/json'
      tags :about

      response(200, 'successful') do
        schema anyOf: [{ '$ref': '#/definitions/about_text' }, {}]

        let!(:about) { create(:about) }
        let(:about_late) { create(:about, created_at: 3.minutes.ago) }

        run_test! do
          expect(JSON.parse(response.body)['data']['attributes']['body']).to eq(about.body)
        end
      end

      response(204, 'no_content') do
        run_test!
      end
    end
  end
end
