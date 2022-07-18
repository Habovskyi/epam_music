describe 'admin/genres', type: :request do
  let(:user) { create(:admin_user) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }
  let!(:genre) { create(:genre) }

  before { sign_in user }

  describe 'GET index' do
    before { get admin_genres_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the genre' do
      expect(assigns(:genres)).to match([genre])
    end

    it 'renders the expected columns' do
      expect(page).to include(genre.id)
      expect(page).to(include { genre.name })
      expect(page).to include(genre.created_at.to_fs(:long))
      expect(page).to include(genre.updated_at.to_fs(:long))
    end
  end

  describe 'GET show' do
    before { get admin_genre_path(genre) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the genre' do
      expect(assigns(:genre)).to match(genre)
    end

    it 'renders the expected columns' do
      expect(page).to include(genre.name)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      let(:last_genre) { Genre.order(:created_at).last }
      let(:attributes) { attributes_for(:genre) }

      it 'creates a new genre' do
        expect do
          post admin_genres_path, params: { genre: attributes }
        end.to change(Genre, :count).by(1)
      end

      it 'redirects to the created genre' do
        post admin_genres_path, params: { genre: attributes }
        expect(response).to have_http_status(:redirect)
      end

      it 'renders expected fields' do
        post admin_genres_path, params: { genre: attributes }
        expect(last_genre.name).to eq(attributes[:name])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { name: '12233' } }

      it 'return http success' do
        post admin_genres_path, params: { genre: attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create new author' do
        expect do
          post admin_genres_path, params: { genre: attributes }
        end.not_to change(Author, :count)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      before { put admin_genre_path(genre), params: { genre: attributes } }

      let(:attributes) { { name: 'New genre' } }

      it 'assigns the right genre' do
        expect(assigns(:genre).model).to eq(genre)
      end

      it 'updates genre' do
        genre.reload
        expect(genre.name).to eq(attributes[:name])
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_genre_path(genre))
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { name: '1234' } }

      it 'does not change genre' do
        expect do
          put admin_genre_path(genre), params: { genre: attributes }
        end.not_to(change { genre.reload.name })
      end
    end
  end
end
