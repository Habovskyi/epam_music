describe 'admin/songs', type: :request do
  let!(:song) { create(:song) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in create(:admin_user) }

  describe 'GET index' do
    let(:data) do
      [song.id, song.title, song.genre.name, song.author.nickname,
       song.album.title, 'Created At', 'Updated At', 'Featured']
    end

    before { get admin_songs_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns songs' do
      expect(assigns(:songs)).to match([song])
    end

    it 'renders the expected columns' do
      data.map { |item| expect(page).to include(item) }
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      let(:song) do
        build(:song).attributes.slice('title', 'album_id', 'genre_id', 'author_id')
      end

      let(:last_song) { Song.order(:created_at).last }

      it 'creates a new admin song' do
        expect do
          post admin_songs_path, params: { song: }
        end.to change(Song, :count).by(1)
      end

      it 'redirects to the created admin song' do
        post admin_songs_path, params: { song: }
        expect(response).to have_http_status(:redirect)
      end

      it 'has right song properties' do
        post admin_songs_path, params: { song: }
        expect(last_song.title).to eq(song['title'])
        expect(last_song.album_id).to eq(song['album_id'])
        expect(last_song.genre_id).to eq(song['genre_id'])
        expect(last_song.author_id).to eq(song['author_id'])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) do
        { title: '',
          album_id: '123',
          genre_id: 'no-exist',
          author_id: '123',
          featured: 'undefined' }
      end

      it 'invalid_attributes return http success' do
        post admin_songs_path, params: { song: attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create new song' do
        expect do
          post admin_songs_path, params: { song: attributes }
        end.not_to change(Song, :count)
      end
    end
  end

  describe 'GET new' do
    before { get new_admin_song_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the song' do
      expect(assigns(:song).model).to be_a_new(Song)
    end

    it 'renders the form elements' do
      expect(page).to include('Title')
      expect(page).to include('Genre')
      expect(page).to include('Author')
      expect(page).to include('Album')
      expect(page).to include('Featured')
    end
  end

  describe 'GET show' do
    let(:data) do
      [song.id, song.title, song.genre.name, song.author.nickname,
       song.album.title, 'Created At', 'Updated At', 'Featured']
    end

    before { get admin_song_path(song) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the right song' do
      expect(assigns(:song)).to match(song)
    end

    it 'renders the expected columns' do
      data.map { |item| expect(page).to include(item) }
    end
  end

  describe 'PUT update' do
    let(:attributes) do
      { title: 'New title',
        album_id: song.album_id,
        genre_id: song.genre_id,
        author_id: song.author_id,
        featured: true }
    end

    context 'with valid params' do
      before do
        put admin_song_path(song), params: { song: attributes }
      end

      it 'assigns the right song' do
        expect(assigns(:song).model).to eq(song)
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_song_path(song))
      end

      it 'updates song' do
        song.reload

        expect(song.title).to eq(attributes[:title])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) do
        { title: '',
          album_id: '123',
          genre_id: 'no-exist',
          author_id: '123',
          featured: 'undefined' }
      end

      it 'does not change song' do
        expect do
          put admin_song_path(song), params: { song: attributes }
        end.not_to(change { song.reload.title })
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys song' do
      expect do
        delete admin_song_path(song)
      end.to change(Song, :count).by(-1)
    end

    it 'redirects to the root' do
      delete admin_song_path(song)
      expect(response).to redirect_to(admin_songs_path)
    end
  end
end
