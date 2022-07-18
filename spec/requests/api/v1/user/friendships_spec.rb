require 'swagger_helper'

RSpec.describe 'api/v1/user/friendships', type: :request do
  path '/api/v1/user/friendships' do
    get('list invitation') do
      consumes 'application/json'
      produces 'application/json'
      tags :friendships

      security [Bearer: []]

      let(:user) { create(:user) }

      describe 'as guest' do
        let(:Authorization) { nil }
        let(:user_to_id) { user.id }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        let(:user1) { create(:user) }
        let(:Authorization) { authorization(user1) }

        context 'with exist data' do
          response(200, 'success') do
            schema type: :object,
                   anyOf: [{ '$ref': '#/definitions/list_invitations' }, {}]

            before do
              create(:friendship, user_from_id: user1.id, user_to_id: create(:user).id)
              create(:friendship, user_from_id: create(:user).id, user_to_id: user1.id)
            end

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Friendship::MANY_SCHEMA)
            end
          end
        end
      end
    end

    post('create friendship') do
      consumes 'multipart/form-data'
      tags :friendships

      security [Bearer: []]
      parameter name: :user_to_id, in: :formData, required: true

      let!(:friend) { create(:user) }

      describe 'as guest' do
        let(:Authorization) { nil }
        let(:user_to_id) { friend.id }

        response(401, 'unauthorized') do
          run_test!
        end
      end

      describe 'as user' do
        let(:user) { create(:user) }
        let(:Authorization) { authorization(user) }
        let(:user_to_id) { friend.id }

        context 'with valid data' do
          response(200, 'success') do
            schema type: :object,
                   '$ref': '#/definitions/friendship'

            run_test! do
              expect(response.body).to match_response_schema(Api::Schemas::Friendship::SINGLE_SCHEMA)
            end
          end
        end

        describe 'mailer' do
          it 'sends propper email' do
            expect do
              post api_v1_user_friendships_path(user_to_id:),
                   headers: { Authorization: authorization(user) }
            end.to have_enqueued_mail(FriendshipMailer, :invintation_mail)
          end
        end

        context 'with invalid data' do
          response(400, 'bad_request') do
            let(:user_to_id) { nil }

            run_test!
          end

          response(400, 'bad_request') do
            schema type: :object,
                   properties: {
                     errors: { type: :object }
                   }

            let(:user_to_id) { user.id }

            run_test!
          end

          response(400, 'bad_request') do
            let(:user_to_id) { 'invalid_id' }

            run_test!
          end

          response(400, 'bad_request') do
            before do
              create(:friendship, user_from: user, user_to: friend)
            end

            run_test!
          end
        end
      end
    end
  end

  path '/api/v1/user/friendships/{id}' do
    parameter name: :id, in: :path, type: :string

    put('update friendship') do
      consumes 'multipart/form-data'
      tags :friendships

      security [Bearer: []]

      subject!(:friendship) { create(:friendship, :pending) }

      let(:id) { friendship.id }
      let(:user) { friendship.user_to }
      let(:Authorization) { authorization(user) }

      describe 'as guest' do
        let(:Authorization) { nil }

        response(401, 'Forbidden') do
          run_test!
        end
      end

      describe 'mailer' do
        it 'sends propper email' do
          expect do
            put api_v1_user_friendship_path(create(:friendship, user_to: user)),
                headers: { Authorization: authorization(user) }
          end.to have_enqueued_mail(FriendshipMailer, :accepted_mail)
        end
      end

      describe 'as user' do
        context 'with valid data' do
          response(204, 'updated') do
            run_test! do
              perform_enqueued_jobs
              expect(ActionMailer::Base.deliveries.count).to eq(1)
            end
          end
        end

        context 'with invalid data' do
          response(404, 'not found') do
            let(:id) { create(:friendship, :pending).id }

            run_test!
          end

          response(404, 'not found') do
            let(:id) { create(:friendship, :pending, user_from: user).id }

            run_test!
          end

          response(404, 'not found') do
            before do
              friendship.update(status: :accepted)
            end

            run_test!
          end
        end
      end
    end

    delete('delete friendship') do
      consumes 'application/json'
      produces 'application/json'
      tags :friendships

      let(:user) { create(:user) }
      let(:Authorization) { authorization(user) }
      let(:id) { create(:friendship, user_from_id: user.id).id }

      security [Bearer: []]

      describe 'mailer' do
        let(:new_friendship) { create(:friendship, user_to: user) }

        it 'sends propper email' do
          expect do
            delete api_v1_user_friendship_path(new_friendship),
                   headers: { Authorization: authorization(user) }
          end.to have_enqueued_mail(FriendshipMailer, :declined_mail)
        end
      end

      response(204, 'no content') do
        run_test! do
          expect(Friendship).not_to be_exist(id:)
          perform_enqueued_jobs
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }

        run_test!
      end
    end
  end
end
