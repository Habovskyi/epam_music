describe 'admin/albums', type: :request do
  let!(:album) { create(:album) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in create(:admin_user) }

  describe 'Index' do
    before { get admin_albums_path }

    it 'shows correct data' do
      expect(response).to be_truthy
      expect(page).to include(album.title)
      expect(page).to include(album.id)
    end
  end

  describe 'New' do
    before { get new_admin_album_path }

    it 'shows title on form' do
      expect(page).to include('Title')
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      let(:attributes) { attributes_for(:album) }
      let(:last_album) { Album.order(:created_at).last }

      it 'creates a new album' do
        expect do
          post admin_albums_path, params: { album: attributes }
        end.to change(Album, :count).by(1)
      end

      it 'redirects to the created album' do
        post admin_albums_path, params: { album: attributes }
        expect(response).to have_http_status(:redirect)
      end

      it 'has right album properties' do
        post admin_albums_path, params: { album: attributes }
        expect(last_album.title).to eq(attributes[:title])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { title: '' } }

      it 'invalid_attributes return http success' do
        post admin_albums_path, params: { album: attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create new album' do
        expect do
          post admin_albums_path, params: { album: attributes }
        end.not_to change(Album, :count)
      end
    end
  end

  describe 'Show' do
    before { get admin_album_path(album) }

    it 'shows' do
      expect(page).to include(album.title)
    end
  end

  describe 'Edit' do
    before { get edit_admin_album_path(album) }

    let(:page) { Nokogiri::HTML.parse(response.body) }
    let(:title) do
      page.at('input[name="album[title]"]').attributes['value'].value
    end

    it 'shows title' do
      expect(title).to eq(album.title)
    end
  end

  describe 'PUT tests' do
    let(:attributes) { attributes_for(:album) }

    context 'with valid params' do
      before { put admin_album_path(album), params: { album: attributes } }

      it 'assigns the right album' do
        expect(assigns(:album).model).to eq(album)
      end

      it 'updates album' do
        album.reload
        expect(album.title).to eq(attributes[:title])
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_album_path(album))
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { title: '' } }

      it 'does not change album' do
        expect do
          put admin_album_path(album), params: { album: attributes }
        end.not_to(change { album.reload.title })
      end
    end
  end

  describe 'DELETE' do
    it 'destroys album' do
      expect do
        delete admin_album_path(album)
      end.to change(Album, :count).by(-1)
    end

    it 'redirects to the root' do
      delete admin_album_path(album)
      expect(response).to redirect_to(admin_albums_path)
    end
  end
end
