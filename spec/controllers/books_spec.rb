# frozen_string_literal: true

# Specs for the index action of books module
RSpec.describe BooksController, type: :controller do
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
      expect(response.body).to include(*Book.all.map(&:title))
    end
  end

  describe '#show' do
    let(:book) { create(:book) }

    context 'when the book exists' do
      before { get :show, params: { id: book.id } }

      it 'returns a ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'renders the received book and it details' do
        expect(response.body).to include(book.title, book.author, book.reviews)
      end
    end

    context 'when the book does not exist' do
      before { get :show, params: { id: 0 } }

      it 'returns a not found http status' do
        expect(response).to have_http_status(:not_found)
      end

      it 'raises a error' do
        expect { get :show, params: { id: 0 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
