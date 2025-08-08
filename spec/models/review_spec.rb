# frozen_string_literal: true

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_presence_of(:comment) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
    it { should validate_length_of(:comment).is_at_most(1000) }

    it 'has a valid factory' do
      review = build(:review)
      expect(review).to be_valid
    end
  end

  describe 'scopes' do
    describe '.from_active_users' do
      let(:valid_review) { create(:review, rating: 4) }
      let(:banned_review) { create(:review, :from_banned_user, rating: 5) }

      it 'returns only reviews from active users' do
        expect(described_class.from_active_users).to include(valid_review)
      end

      it 'does not return reviews from banned users' do
        expect(described_class.from_active_users).not_to include(banned_review)
      end
    end
  end
end
