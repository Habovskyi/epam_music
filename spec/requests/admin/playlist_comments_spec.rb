describe 'admin/playlist_comments' do
  let(:user) { create(:admin_user) }
  let(:page) { Nokogiri::HTML.parse(response.body).text }
  let!(:comment) { create(:comment) }

  before { sign_in user }

  describe 'GET index' do
    before { get admin_playlist_comments_path }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the about' do
      expect(assigns(:playlist_comments)).to match([comment])
    end

    it 'renders the expected columns' do
      expect(page).to include(comment.id)
      expect(page).to include(comment.text)
      expect(page).to include(comment.created_at.to_fs(:long))
      expect(page).to include(comment.updated_at.to_fs(:long))
    end

    it 'renders assosiations' do
      expect(page).to include(comment.user.username)
      expect(page).to include(comment.playlist.title)
    end
  end

  describe 'GET show' do
    before { get admin_playlist_comment_path(comment) }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the comment' do
      expect(assigns(:playlist_comment)).to match(comment)
    end

    it 'renders the expected columns' do
      expect(page).to include(comment.user.username)
      expect(page).to include(comment.playlist.title)
      expect(page).to include(comment.text)
    end
  end
end
