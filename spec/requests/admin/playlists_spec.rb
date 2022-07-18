describe 'admin/playlists', type: :request do
  let!(:playlist) { create(:playlist) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in create(:admin_user) }

  describe 'Index' do
    before { get admin_playlists_path }

    it 'shows correct data' do
      expect(response).to be_truthy
      expect(page).to include('Yes')
      expect(page).to include(playlist.title)
      expect(page).to include(playlist.id)
    end
  end

  describe 'Show' do
    before { get admin_playlist_path(playlist) }

    it 'shows playlist details' do
      expect(page).to include(playlist.title)
      expect(page).to include(playlist.featured ? 'Yes' : 'No')
    end
  end

  describe 'PUT tests' do
    let(:attributes) { attributes_for(:playlist) }

    context 'with valid params' do
      before { put admin_playlist_path(playlist), params: { playlist: attributes } }

      it 'assigns the right playlist' do
        expect(assigns(:playlist)).to eq(playlist)
      end

      it 'updates playlist' do
        playlist.reload
        expect(playlist.featured).to eq(attributes[:featured])
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_playlist_path(playlist))
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { featured: [] } }

      it 'does not change playlist' do
        expect do
          put admin_playlist_path(playlist), params: { playlist: attributes }
        end.not_to(change { playlist.reload.featured })
      end
    end
  end
end
