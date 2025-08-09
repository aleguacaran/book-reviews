# frozen_string_literal: true

# Specs for the index action of books module
RSpec.describe BooksController do
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
    before do
      create_list(:book, 3)
      get :index
    end

    it 'returns a ok http status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'renders all existing books' do
      titles = Book.all.map { |book| CGI.escapeHTML(book.title) }
      expect(response.body).to include(*titles)
    end
  end

  describe '#new' do
    before { get :new }

    it 'returns a ok http status' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end

    it 'renders a form to create a new book' do
      expect(response.body).to include('form', 'New Book', 'Create Book')
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:valid_params) { { book: attributes_for(:book) } }

      before { post :create, params: valid_params }

      it 'redirects to the show page' do
        expect(response).to redirect_to(book_path(Book.last))
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('Book was successfully created.')
      end

      it 'creates a new book' do
        expect { post :create, params: valid_params }.to change(Book, :count).by(1)
      end

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { book: attributes_for(:book, title: nil) } }

      before { post :create, params: invalid_params }

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'does not create a new book' do
        expect { post :create, params: invalid_params }.not_to change(Book, :count)
      end

      it 'returns an unprocessable entity http status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the book errors' do
        expect(response.body).to include(CGI.escapeHTML("Title can't be blank"))
      end
    end
  end

  describe '#edit' do
    context 'when the book exists' do
      let(:book) { create(:book) }

      before { get :edit, params: { id: book.id } }

      it 'returns a ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'renders a form to edit the book' do
        expect(response.body).to include('form', CGI.escapeHTML("Editing #{book.title}"),
                                         'Update Book')
      end
    end

    context 'when the book does not exist' do
      before { get :edit, params: { id: 0 } }

      it_behaves_like 'book not found'
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      let(:book) { create(:book) }

      before { put :update, params: { id: book.id, book: { title: 'New title' } } }

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to the show page' do
        expect(response).to redirect_to(book_path(book))
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('Book was successfully updated.')
      end

      it 'updates the book title' do
        book.reload
        expect(book).to have_attributes(title: 'New title')
      end
    end

    context 'with invalid parameters' do
      let(:book) { create(:book) }

      before { put :update, params: { id: book.id, book: { title: nil } } }

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'does not update the book' do
        book.reload
        expect(book).not_to have_attributes(title: nil)
      end

      it 'returns an unprocessable entity http status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the book errors' do
        expect(response.body).to include(CGI.escapeHTML("Title can't be blank"))
      end
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
        expect(response.body).to include(CGI.escapeHTML(book.title), CGI.escapeHTML(book.author),
                                         book.displayed_rating)
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
