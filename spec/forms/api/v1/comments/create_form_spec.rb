RSpec.describe Api::V1::Comments::CreateForm, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  subject(:comment) { described_class.new(user.comments.new(playlist:)) }

  let(:playlist) { create(:playlist, user:) }
  let(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.not_to allow_value(nil).for(:text) }

    it do
      expect(comment).to validate_length_of(:text)
        .is_at_least(described_class::TEXT_MIN_LENGTH).is_at_most(described_class::TEXT_MAX_LENGTH)
    end

    context 'with valid values' do
      let(:valid_texts) { ['Dolore unde', 'nobis', 'mollitia voluptas dignissimos maxime.', 'Saepe quod pariatur cum'] }

      it 'allows correct texts' do
        expect(comment).to allow_values(*valid_texts)
          .for(:text)
      end
    end

    context 'with invalid values' do
      let(:invalid_texts) { %w[a ab 4] }

      it "doesn't allow invalid texts" do
        expect(comment).not_to allow_values(*invalid_texts)
          .for(:text)
      end
    end
  end

  describe 'cooldown' do
    let(:text) { 'Comment text' }
    let(:new_comment) { described_class.new(user.comments.new(playlist: create(:playlist, user:))) }

    before do
      comment.validate(text:)
      comment.save
    end

    it "doesn't allows to make comment until cooldown" do
      expect(new_comment.validate(text:)).to be_falsey
    end

    it 'allow save after cooldown' do
      travel_to (described_class::COOLDOWN_TIME + 1.second).from_now
      expect(new_comment.validate(text:)).to be_truthy
    end
  end
end
