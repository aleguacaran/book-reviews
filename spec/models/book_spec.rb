# frozen_string_literal: true

RSpec.describe Book do
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

  describe '#displayed_rating' do
    let(:book) { create(:book) }

    context 'with no rating' do
      it 'returns Insufficient reviews' do
        book.rating = nil
        expect(book.displayed_rating).to eq('Insufficient reviews')
      end
    end

    context 'with a positive rating' do
      it 'returns the float rating' do
        book.rating = 4.5
        expect(book.displayed_rating).to eq(book.rating)
      end
    end
  end

  describe '#update_rating!' do
    let(:book) { create(:book) }

    context 'with fewer than 3 reviews' do
      before { create_list(:review, 2, book: book) }

      it 'sets rating to nil' do
        book.update_rating!
        expect(book).to have_attributes(rating: nil)
      end
    end

    context 'with 3 or more reviews' do
      before do
        create_list(:review, 3, book: book, rating: 4)
        create_list(:review, 2, :from_banned_user, book: book, rating: 1)
      end

      it 'calculates and saves the correct average rating' do
        book.update_rating!
        avg = book.reviews.pluck(:rating).sum.to_f / book.reviews.count
        expect(book).to have_attributes(rating: avg.round(1))
      end
    end
  end
end
