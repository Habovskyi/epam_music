RSpec.describe 'api/v1/user/friends', type: :request do
  path '/api/v1/user/friends' do
    let(:user) { create(:user) }
    let(:Authorization) { authorization(user) }

    get('list of friends') do
      produces 'application/json'
      tags :friendships

      security [Bearer: []]

      describe 'as guest' do
        let(:Authorization) { nil }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        before do
          create(:friendship, user_to: user)
          create(:friendship, user_from: user)
        end

        context 'with people i invited to be friends' do
          let!(:friend) { create(:friendship, :accepted, user_from: user).user_to }

          response(200, 'success') do
            schema anyOf: [{ '$ref': '#/definitions/friends' }, {}]

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::User::MANY_SCHEMA)
              parsed_body = JSON.parse(response.body)
              expect(parsed_body['data'].length).to eq 1
              expect(parsed_body['data'].first['id']).to eq friend.id
            end
          end
        end

        context 'with people who invited me to be friends' do
          let!(:friend) { create(:friendship, :accepted, user_to: user).user_from }

          response(200, 'success') do
            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::User::MANY_SCHEMA)
              parsed_body = JSON.parse(response.body)
              expect(parsed_body['data'].length).to eq 1
              expect(parsed_body['data'].first['id']).to eq friend.id
            end
          end
        end

        context 'when in friendship with active and inactive user' do
          let(:page) { Nokogiri::HTML.parse(response.body).text }
          let(:active_friend) { create(:user) }
          let(:inactive_friend) { create(:user, :inactive) }

          before do
            create(:accepted_friendship, user_to: inactive_friend, user_from: user)
            create(:accepted_friendship, user_to: active_friend, user_from: user)
          end

          response(200, 'success') do
            run_test! do
              parsed_body = JSON.parse(response.body)
              expect(parsed_body['data'].length).to eq 1
              expect(parsed_body['data'].first['id']).to eq active_friend.id
              expect(page).to include(active_friend.username)
              expect(page).not_to include(inactive_friend.username)
            end
          end
        end
      end
    end
  end
end
