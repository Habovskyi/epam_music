describe 'admin/admin_users', type: :request do
  let(:user) { create(:admin_user) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in user }

  describe 'GET index' do
    before { get admin_admin_users_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the admin user' do
      expect(assigns(:admin_users)).to match([user])
    end

    it 'renders the expected columns' do
      expect(page).to include(user.id)
      expect(page).to include(user.email)
      expect(page).to include(user.created_at.to_fs(:long))
      expect(page).not_to include(user.password)
    end
  end

  describe 'GET show' do
    before { get admin_admin_user_path(user) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the admin user' do
      expect(assigns(:admin_user)).to match(user)
    end

    it 'renders the expected columns' do
      expect(page).to include(user.email)
      expect(page).to include(user.created_at.to_fs(:long))
      expect(page).not_to include(user.password)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      let(:attributes) { attributes_for(:admin_user) }
      let(:last_user) { AdminUser.order(:created_at).last }

      it 'creates a new Admin User' do
        expect do
          post admin_admin_users_path, params: { admin_user: attributes }
        end.to change(AdminUser, :count).by(1)
      end

      it 'redirects to the created Admin user' do
        post admin_admin_users_path, params: { admin_user: attributes }
        expect(response).to have_http_status(:redirect)
      end

      it 'has right admin properties' do
        post admin_admin_users_path, params: { admin_user: attributes }
        expect(last_user.email).to eq(attributes[:email])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { email: 'invalid', password: 'invalid', password_confirmation: 'not match' } }

      it 'invalid_attributes return http success' do
        post admin_admin_users_path, params: { admin_user: attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create a Admin user' do
        expect do
          post admin_admin_users_path, params: { admin_user: attributes }
        end.not_to change(AdminUser, :count)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      let(:attributes) { attributes_for(:admin_user) }

      before do
        put admin_admin_user_path(user), params: { admin_user: attributes }
      end

      it 'assigns the admin user' do
        expect(assigns(:admin_user)).to eq(user)
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_admin_user_path(user))
      end

      it 'updates the person' do
        user.reload

        expect(user.email).to eq(attributes[:email])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { email: 'invalid' } }

      it 'does not change person' do
        expect do
          put admin_admin_user_path(user), params: { admin_user: attributes }
        end.not_to(change { user.reload.email })
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested select_option' do
      expect do
        delete admin_admin_user_path(user)
      end.to change(AdminUser, :count).by(-1)
    end

    it 'redirects to the field' do
      delete admin_admin_user_path(user)
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end
end
