describe 'admin/authors', type: :request do
  let!(:author) { create(:author) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }

  before { sign_in create(:admin_user) }

  describe 'Index' do
    before { get admin_authors_path }

    it 'shows correct data' do
      expect(response).to be_truthy
      expect(page).to include(author.nickname)
    end
  end

  describe 'New' do
    before { get new_admin_author_path }

    it 'shows nickname on form' do
      expect(page).to include('Nickname')
    end
  end

  describe 'POST create' do
    let(:attributes) { attributes_for(:author) }
    let(:last_author) { Author.order(:created_at).last }

    context 'with valid params' do
      it 'creates a new author' do
        expect do
          post admin_authors_path, params: { author: attributes }
        end.to change(Author, :count).by(1)
      end

      it 'redirects to the created author' do
        post admin_authors_path, params: { author: attributes }
        expect(response).to have_http_status(:redirect)
      end

      it 'shows the rigth attributes' do
        post admin_authors_path, params: { author: attributes }
        expect(last_author.nickname).to eq(attributes[:nickname])
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { nickname: '' } }

      it 'invalid_attributes return http success' do
        post admin_authors_path, params: { author: attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create new author' do
        expect do
          post admin_authors_path, params: { author: attributes }
        end.not_to change(Author, :count)
      end
    end
  end

  describe 'Show' do
    before { get admin_author_path(author) }

    it 'shows' do
      expect(page).to include(author.nickname)
    end
  end

  describe 'Edit' do
    before { get edit_admin_author_path(author) }

    let(:page) { Nokogiri::HTML.parse(response.body) }
    let(:nickname) do
      page.at('input[name="author[nickname]"]').attributes['value'].value
    end

    it 'shows nickname' do
      expect(nickname).to eq(author.nickname)
    end
  end

  describe 'PUT tests' do
    let(:attributes) { attributes_for(:author) }

    context 'with valid params' do
      before do
        put admin_author_path(author), params: { author: attributes }
        author.reload
      end

      it 'assigns the right author' do
        expect(assigns(:author).model).to eq(author)
      end

      it 'updates author' do
        expect(author.nickname).to eq(attributes[:nickname])
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_author_path(author))
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { nickname: '' } }

      it 'does not change author' do
        expect do
          put admin_author_path(author), params: { author: attributes }
        end.not_to(change { author.reload.nickname })
      end
    end
  end

  describe 'DELETE' do
    it 'destroys author' do
      expect do
        delete admin_author_path(author)
      end.to change(Author, :count).by(-1)
    end

    it 'redirects to the root' do
      delete admin_author_path(author)
      expect(response).to redirect_to(admin_authors_path)
    end
  end
end
