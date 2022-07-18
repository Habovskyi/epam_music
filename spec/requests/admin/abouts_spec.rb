describe 'admin/abouts', type: :request do
  include RSpec::Rails::ViewRendering
  include Devise::Test::IntegrationHelpers

  render_views

  let!(:user) { create(:admin_user) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }
  let!(:about) { create(:about, body: 'Cool about') }

  before { sign_in user }

  describe 'GET index' do
    before { get admin_abouts_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the about' do
      expect(assigns(:abouts)).to match([about])
    end

    it 'renders the expected columns' do
      expect(page).to include(about.id)
      expect(page).to(include { truncate(about.body.to_plain_text, length: MAX_BODY_INDEX_LENGTH) })
      expect(page).to include(about.created_at.to_fs(:long))
      expect(page).to include(about.updated_at.to_fs(:long))
    end
  end

  describe 'GET show' do
    before { get admin_about_path(about) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the about' do
      expect(assigns(:about)).to match(about)
    end

    it 'renders the expected columns' do
      expect(page).to include(about.body)
    end
  end

  describe 'POST create' do
    let(:last_about) { About.order(:created_at).last }

    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:about) }

      it 'creates a new about' do
        expect do
          post admin_abouts_path, params: { about: valid_attributes }
        end.to change(About, :count).by(1)
      end

      it 'redirects to the created about' do
        post admin_abouts_path, params: { about: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_about_path(last_about))
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:about) }

      before do
        put admin_about_path(about), params: { about: valid_attributes }
      end

      it 'assigns the about' do
        expect(assigns(:about)).to eq(about)
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_about_path(about))
      end

      it 'updates the about' do
        about.reload

        expect(about.body).to eq(valid_attributes[:body])
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested about' do
      expect do
        delete admin_about_path(about)
      end.to change(About, :count).by(-1)
    end

    it 'redirects to the field' do
      delete admin_about_path(about)
      expect(response).to redirect_to(admin_abouts_path)
    end
  end
end
