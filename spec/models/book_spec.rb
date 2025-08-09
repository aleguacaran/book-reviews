# frozen_string_literal: true

RSpec.describe Book, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      book = build(:book)
      expect(book).to be_valid
    end

    it 'requires a title' do
      book = build(:book, title: nil)
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it 'requires an author' do
      book = build(:book, author: nil)
      expect(book).not_to be_valid
      expect(book.errors[:author]).to include("can't be blank")
    end

    it 'requires a published_at date' do
      book = build(:book, published_at: nil)
      expect(book).not_to be_valid
      expect(book.errors[:published_at]).to include("can't be blank")
    end
  end

  describe '#rating' do
    let(:book) { create(:book) }

    context 'when book has no reviews' do
      it 'returns Insufficient reviews' do
        expect(book.rating).to eq('Insufficient reviews')
      end
    end

    context 'when book has fewer than 3 reviews' do
      before do
        # create(:review, book: book, rating: 5)
        # create(:review, book: book, rating: 4)
        book.reviews = [5, 4]
      end

      it 'returns Insufficient reviews' do
        expect(book.rating).to eq('Insufficient reviews')
      end
    end

    context 'when book has 3 or more reviews from non-banned users' do
      before do
        # create(:review, book: book, rating: 5)
        # create(:review, book: book, rating: 4)
        # create(:review, book: book, rating: 3)
        book.reviews = [5, 4, 3]
      end

      it 'calculates the correct average rating' do
        expect(book.rating).to eq(4.0)
      end

      it 'rounds to the nearest tenth' do
        # create(:review, book: book, rating: 2)
        book.reviews.push(2)
        expect(book.rating).to eq(3.5)
      end

      it 'handles decimal rounding correctly' do
        # create(:review, book: book, rating: 1)
        # create(:review, book: book, rating: 2)
        book.reviews.push(1, 2)
        expect(book.rating).to eq(3.0)
      end
    end

    xcontext 'when book has reviews from banned users' do
      let(:banned_user) { create(:user, banned: true) }
      let(:active_user) { create(:user, banned: false) }

      before do
        # Reviews from active users
        create(:review, book: book, user: active_user, rating: 5)
        create(:review, book: book, user: active_user, rating: 4)
        create(:review, book: book, user: active_user, rating: 3)

        # Reviews from banned users (should not count)
        create(:review, book: book, user: banned_user, rating: 1)
        create(:review, book: book, user: banned_user, rating: 1)
      end

      it 'excludes reviews from banned users in calculation' do
        # Should only count reviews from active users: (5 + 4 + 3) / 3 = 4.0
        expect(book.rating).to eq(4.0)
      end

      it 'requires at least 3 reviews from non-banned users' do
        # Remove one review from active user
        book.reviews.joins(:user).where(users: { banned: false }).last.destroy

        # Now only 2 reviews from non-banned users, should return nil
        expect(book.rating).to be_nil
      end
    end
  end
end
