# frozen_string_literal: true

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:published_at) }

    it 'has a valid factory' do
      book = build(:book)
      expect(book).to be_valid
    end
  end

  describe '#rating' do
    let(:book) { create(:book) }

    context 'with no reviews' do
      it 'returns Insufficient reviews' do
        expect(book.rating).to eq('Insufficient reviews')
      end
    end

    context 'with fewer than 3 reviews' do
      before { create_list(:review, 2, book: book) }

      it 'returns Insufficient reviews' do
        expect(book.rating).to eq('Insufficient reviews')
      end
    end

    context 'with 3 or more reviews' do
      let(:ratings) { book.reviews.pluck(:rating) }

      before do
        create_list(:review, 3, book: book, rating: 4)
        create_list(:review, 1, :from_banned_user, book: book, rating: 1)
      end

      it 'returns a float rating' do
        expect(book.rating).to be_a(Float)
      end

      it 'does not include banned reviews' do
        expect(book.reviews.from_banned_users).to be_empty
      end

      it 'calculates the correct average rating' do
        avg = ratings.sum.to_f / ratings.count
        expect(book.rating).to eq(avg)
      end
    end
  end
end
