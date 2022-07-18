require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.file_fixture_path = 'spec/fixtures/logo'
end

RSpec.describe LogoUploader, type: :uploader do
  describe 'logo data' do
    context 'with logo' do
      subject(:logo) { playlist.logo }

      before do
        create(:playlist, title: 'Concentration', logo: file_fixture('test_logo.png').open)
      end

      let(:derivatives) { playlist.logo_derivatives }
      let(:playlist) { Playlist.last }

      it 'destroying logo' do
        playlist.remove_logo = 'true'
        playlist.save
        expect(logo).to be_nil
      end

      it 'extracts mime_type' do
        expect(logo.mime_type).to eq('image/png')
      end

      it 'extracts size' do
        expect(logo.size).to be <= LogoUploader::MAX_SIZE
      end

      it 'have small derivative' do
        expect(derivatives[:small].dimensions).to  match_array(LogoUploader::THUMBNAILS_SIZES[:small])
      end

      it 'have large derivative' do
        expect(derivatives[:large].dimensions).to  match_array(LogoUploader::THUMBNAILS_SIZES[:large])
      end
    end
  end

  describe 'validations' do
    let(:playlist) { build(:playlist) }

    it 'is not of allowed type' do
      playlist.logo = File.open('spec/fixtures/logo/favicon.ico', 'rb')
      playlist.valid?
      expect(playlist.errors[:logo])
        .to include(I18n.t('activerecord.errors.image.not_image', allowed_types: LogoUploader::ALLOWED_MIME_TYPES))
    end

    context 'with too big logo' do
      before do
        playlist.logo = File.open('spec/fixtures/avatar/to_big_size.jpg', 'rb')
      end

      it 'is not within upload limits' do
        playlist.valid?
        expect(playlist.errors[:logo])
          .to include(I18n.t('activerecord.errors.image.too_big_size', max_size: LogoUploader::MAX_SIZE))
      end

      it 'is not within dimensions limits' do
        playlist.valid?
        expect(playlist.errors[:logo])
          .to include(I18n.t('activerecord.errors.image.too_big_dim', dim: [LogoUploader::MAX_DIM_SIZE] * 2))
      end
    end
  end
end
