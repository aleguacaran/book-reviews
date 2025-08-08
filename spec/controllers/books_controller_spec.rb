# frozen_string_literal: true

# Specs for the index action of books module
RSpec.describe BooksController, type: :controller do
  shared_examples 'book not found' do
    it 'redirects to the books index' do
      expect(response).to redirect_to(books_path)
    end

    it 'returns a redirection http status' do
      expect(response).to have_http_status(:redirect)
    end

    it 'renders a flash error message' do
      expect(flash[:error]).to eq('Book not found')
    end
  end

  describe '#index' do
    before { get :index }

    it 'returns a ok http status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'renders all existing books' do
      create_list(:book, 3)
      get :index
      expect(response.body).to include(*Book.all.map(&:title))
    end
  end

  describe '#show' do
    context 'when the book exists' do
      let(:book) { create(:book) }

      before { get :show, params: { id: book.id } }

      it 'returns a ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'renders the received book and it details' do
        expect(response.body).to include(book.title, book.author, book.rating)
      end
    end

    context 'when the book does not exist' do
      before { get :show, params: { id: 0 } }

      it_behaves_like 'book not found'
    end
  end

  describe '#destroy' do
    context 'when the book exists' do
      let(:book) { create(:book) }

      before { delete :destroy, params: { id: book.id } }

      it 'redirects to the books index' do
        expect(response).to redirect_to(books_path)
      end

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('Book was successfully destroyed.')
      end
    end

    context 'when the book does not exist' do
      before { delete :destroy, params: { id: 0 } }

      it_behaves_like 'book not found'
    end
  end
end
