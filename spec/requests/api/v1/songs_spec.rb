RSpec.describe 'api/v1/songs', type: :request do
  path '/api/v1/songs' do
    parameter name: :search_word,
              in: :query,
              description: 'Search parameter',
              schema: {
                type: :string
              },
              required: false
    parameter name: :page,
              in: :query,
              schema: {
                type: :integer
              },
              required: false
    parameter name: 'includes[]',
              in: :query,
              type: :array,
              collectionFormat: :multi,
              items: {
                type: :string,
                enum: Api::V1::Song::FullSerializer.includes
              },
              required: false
    get('search songs') do
      produces 'application/json'

      tags :songs

      let!(:song) { create(:song) }
      let(:'includes[]') { Api::V1::Song::FullSerializer.includes }

      response(200, 'successful') do
        schema type: :object,
               '$ref': '#/definitions/search_songs'

        run_test! do
          options = { include: Api::V1::Song::FullSerializer.includes }
          expect(response.body).to eq(Api::V1::Song::FullSerializer.new([song], options).to_json)
        end
      end
    end

    after do |example|
      example.metadata[:response][:content] = {
        'application/json' => {
          example: JSON.parse(response.body, symbolize_names: true)
        }
      }
    end
  end
end
