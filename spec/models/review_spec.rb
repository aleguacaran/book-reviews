# frozen_string_literal: true

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:comment) }
    it { is_expected.to validate_numericality_of(:rating)
                    .is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5)
                    .with_message('must be between 1 and 5') }
    it { is_expected.to validate_length_of(:comment).is_at_most(1000) }

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

  describe 'callbacks' do
    describe 'after_save' do
      context 'on create' do
        it 'changes the rating column of the book' do
          book = create(:book)
          expect { create_list(:review, 3, book: book, rating: 4) }.to change(book, :rating).from(nil).to(4.0)
        end
      end

      context 'on update' do
        it 'changes the rating column of the book' do
          book = create(:book)
          create_list(:review, 3, book: book, rating: 4)
          expect { book.reviews.last.update(rating: 2) }.to change(book, :rating).from(4.0).to(3.3)
        end
      end
    end

    describe 'after_destroy' do
      it 'changes the rating column of the book' do
        book = create(:book)
        create_list(:review, 3, book: book, rating: 4)
        expect { book.reviews.destroy_all }.to change(book, :rating).from(4.0).to(nil)
      end
    end
  end
end
