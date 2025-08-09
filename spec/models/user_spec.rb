# frozen_string_literal: true

RSpec.describe User do
  describe 'associations' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }

    it {
      is_expected.to define_enum_for(:status)
        .with_values(active: 'active', banned: 'banned').with_default(:active)
        .backed_by_column_of_type(:string)
    }

    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'after_save' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    before { create_list(:review, 3, user: user, book: book, rating: 4) }

    it '#update_reviewed_books' do
      user.banned!
      expect { book.reload }.to change(book, :rating).from(4.0).to(nil)
    end
  end
end
