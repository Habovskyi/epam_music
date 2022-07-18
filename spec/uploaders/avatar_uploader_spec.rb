require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

RSpec.describe AvatarUploader, type: :uploder do
  describe 'avatar data' do
    context 'with avatar' do
      subject(:avatar) { user.avatar }

      before do
        create(:user_with_avatar)
      end

      let(:derivatives) { user.avatar_derivatives }
      let(:user) { User.last }

      it 'destroing avatar' do
        user.remove_avatar = 'true'
        user.save
        expect(avatar).to be_nil
      end

      it 'extracts mime_type' do
        expect(avatar.mime_type).to eq('image/png')
      end

      it 'extracts size' do
        expect(avatar.size).to be <= AvatarUploader::MAX_SIZE
      end

      it 'extracts width' do
        expect(avatar.width).to be_between(AvatarUploader::MIN_DIM_SIZE, AvatarUploader::MAX_DIM_SIZE)
      end

      it 'extracts height' do
        expect(avatar.height).to be_between(AvatarUploader::MIN_DIM_SIZE, AvatarUploader::MAX_DIM_SIZE)
      end

      it 'have small derivative' do
        expect(derivatives[:small].dimensions).to  match_array(AvatarUploader::THUMBNAILS_SIZES[:small])
      end

      it 'have large derivative' do
        expect(derivatives[:large].dimensions).to  match_array(AvatarUploader::THUMBNAILS_SIZES[:large])
      end
    end

    context 'without avatar' do
      let(:user) { build(:user) }

      it 'have default avatar' do
        expect(user.avatar_url).to eq AvatarUploader::DEFAULT_URL
      end
    end
  end

  describe 'validations' do
    let(:user) { build(:user) }

    it 'is not of allowed type' do
      user.avatar = File.open('spec/fixtures/avatar/wrong_type.gif', 'rb')
      user.valid?
      expect(user.errors[:avatar])
        .to include(I18n.t('activerecord.errors.image.not_image', allowed_types: AvatarUploader::ALLOWED_MIME_TYPES))
    end

    context 'with too big image' do
      before do
        user.avatar = File.open('spec/fixtures/avatar/to_big_size.jpg', 'rb')
      end

      it 'is not within upload limits' do
        user.valid?
        expect(user.errors[:avatar])
          .to include(I18n.t('activerecord.errors.image.too_big_size', max_size: AvatarUploader::MAX_SIZE))
      end

      it 'is not within dimensions limits' do
        user.valid?
        expect(user.errors[:avatar])
          .to include(I18n.t('activerecord.errors.image.too_big_dim', dim: [AvatarUploader::MAX_DIM_SIZE] * 2))
      end
    end

    context 'with too small image' do
      before do
        user.avatar = File.open('spec/fixtures/avatar/to_small_dim.jpg', 'rb')
      end

      it 'is not within dimensions limits' do
        user.valid?
        expect(user.errors[:avatar])
          .to include(I18n.t('activerecord.errors.image.too_small_dim', dim: [AvatarUploader::MIN_DIM_SIZE] * 2))
      end
    end
  end
end
