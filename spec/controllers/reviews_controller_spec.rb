# frozen_string_literal: true

RSpec.describe ReviewsController, type: :controller do
  let(:book) { create(:book) }

  shared_examples 'renders users to select' do
    let(:active_users) { User.active.pluck(:name) }
    let(:banned_users) { User.banned.pluck(:name) }

    before do
      create_list(:user, 3)
      create_list(:user, 2, :banned)
      get :new, params: { book_id: book.id }
    end

    it 'renders active users to select' do
      expect(response.body).to include(*active_users)
    end

    it 'does not render banned users' do
      expect(response.body).not_to include(*banned_users)
    end
  end

  shared_examples 'review not found' do
    it { is_expected.to redirect_to(book) }
    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_flash[:error].to('Review not found') }
  end

  describe '#new' do
    before { get :new, params: { book_id: book.id } }

    it { is_expected.to respond_with(:ok) }
    it { is_expected.to render_template(:new) }

    it 'renders a form to create a new review' do
      expect(response.body).to include('form', 'New review', 'Create Review',
                                       CGI.escapeHTML(book.title))
    end

    it_behaves_like 'renders users to select'
  end

  describe '#create' do
    let(:user) { create(:user) }

    context 'with valid params' do
      let :valid_params do
        { book_id: book.id, review: { user_id: user.id, rating: 4, comment: 'Great book!' } }
      end

      before { post :create, params: valid_params }

      it 'creates a new review' do
        expect { post :create, params: valid_params }.to change(Review, :count).by(1)
      end

      it { is_expected.to redirect_to(book) }
      it { is_expected.to respond_with(:redirect) }
      it { is_expected.to set_flash[:notice].to('Review was successfully created.') }

      it 'updates the book rating' do
        book.reviews.destroy_all
        create_list(:review, 2, book: book, rating: 4)
        post :create, params: valid_params
        expect { book.reload }.to change(book, :rating).from(nil).to(4.0)
      end
    end

    context 'with invalid params' do
      let :invalid_params do
        { book_id: book.id, review: { user_id: user.id, rating: 6, comment: '' } }
      end

      before { post :create, params: invalid_params }

      it 'does not create a review' do
        expect { post :create, params: invalid_params }.not_to change(Review, :count)
      end

      it { is_expected.to render_template(:new) }
      it { is_expected.to respond_with(:unprocessable_content) }

      it 'renders the review errors' do
        expect(response.body).to include('Rating must be between 1 and 5')
      end
    end
  end

  describe '#edit' do
    context 'when the review exists' do
      let(:review) { create(:review, book: book) }

      before { get :edit, params: { book_id: book.id, id: review.id } }

      it { is_expected.to respond_with(:ok) }
      it { is_expected.to render_template(:edit) }

      it 'renders a form to edit the review' do
        expect(response.body).to include('form', 'Edit review', 'Update Review', book.title)
      end

      it_behaves_like 'renders users to select'
    end

    context 'when the review does not exist' do
      before { get :edit, params: { book_id: book.id, id: 99999 } }

      it_behaves_like 'review not found'
    end
  end

  describe '#update' do
    let(:review) { create(:review, book: book) }

    context 'with valid params' do
      let(:new_attrs) { { rating: 5, comment: 'Updated comment' } }

      before { patch :update, params: { book_id: book.id, id: review.id, review: new_attrs } }

      it { is_expected.to redirect_to(book) }
      it { is_expected.to respond_with(:redirect) }
      it { is_expected.to set_flash[:notice].to('Review was successfully updated.') }

      it 'updates the review' do
        review.reload
        expect(review).to have_attributes(new_attrs)
      end

      it 'updates the book rating' do
        book.reviews.destroy_all
        reviews = create_list(:review, 3, book: book, rating: 4)
        patch :update, params: { book_id: book.id, id: reviews.last.id, review: new_attrs }
        expect { book.reload }.to change(book, :rating).from(4.0).to(4.3)
      end
    end

    context 'with invalid params' do
      let(:new_attrs) { { rating: 0, comment: '' } }

      before do
        review.update(rating: 3, comment: 'Original comment')
        patch :update, params: { book_id: book.id, id: review.id, review: new_attrs }
      end

      it { is_expected.to render_template(:edit) }
      it { is_expected.to respond_with(:unprocessable_entity) }

      it 'does not update the review' do
        review.reload
        expect(review).to have_attributes(rating: 3, comment: 'Original comment')
      end

      it 'renders the review errors' do
        expect(response.body).to include('Rating must be between 1 and 5')
      end
    end

    context 'when the review does not exist' do
      before { patch :update, params: { book_id: book.id, id: 99999, review: { rating: 5, comment: 'Updated comment' } } }

      it_behaves_like 'review not found'
    end
  end

  describe '#destroy' do
    context 'when the review exists' do
      define_method(:review) { Review.last }

      before do
        create_list(:review, 3, book: book)
        delete :destroy, params: { book_id: book.id, id: review.id }
      end

      it 'destroys the review' do
        expect { delete :destroy, params: { book_id: book.id, id: review.id } }
          .to change(Review, :count).by(-1)
      end

      it { is_expected.to redirect_to(book) }
      it { is_expected.to respond_with(:redirect) }
      it { is_expected.to set_flash[:notice].to('Review was successfully deleted.') }

      it 'updates the book rating' do
        book.reviews.destroy_all
        create_list(:review, 3, book: book, rating: 4)
        delete :destroy, params: { book_id: book.id, id: review.id }
        expect { book.reload }.to change(book, :rating).from(4.0).to(nil)
      end
    end

    context 'when the review does not exist' do
      before { delete :destroy, params: { book_id: book.id, id: 99999 } }

      it_behaves_like 'review not found'
    end
  end
end
