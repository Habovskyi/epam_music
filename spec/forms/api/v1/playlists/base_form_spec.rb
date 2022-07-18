RSpec.describe Api::V1::Playlists::BaseForm, type: :model do
  describe 'validations' do
    subject(:playlist) { described_class.new(Playlist.new) }

    it { is_expected.not_to allow_value(nil).for(:title) }

    it do
      expect(playlist).to validate_length_of(:title)
        .is_at_least(described_class::TITLE_MIN_LENGTH).is_at_most(described_class::TITLE_MAX_LENGTH)
    end

    it do
      expect(playlist).to validate_length_of(:description)
        .is_at_most(described_class::DESCRIPTION_MAX_LENGTH)
    end

    context 'with valid values' do
      let(:valid_titles) { ['To Relax', 'sportActivity', 'OST Agent007', '777 selected', '000'] }

      it 'allows correct titles' do
        expect(playlist).to allow_values(*valid_titles)
          .for(:title)
      end
    end

    context 'with invalid values' do
      let(:invalid_titles) { ['too long playlist\'s title', '7', '_for_home', '.school party'] }

      it "doesn't allow invalid titles" do
        expect(playlist).not_to allow_values(*invalid_titles)
          .for(:title)
      end
    end
  end
end
