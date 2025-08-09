# frozen_string_literal: true

# Specs for the UsersController
RSpec.describe UsersController, type: :controller do
  shared_examples 'user not found' do
    it 'redirects to the users index' do
      expect(response).to redirect_to(users_path)
    end

    it 'returns a redirection http status' do
      expect(response).to have_http_status(:redirect)
    end

    it 'renders a flash error message' do
      expect(flash[:error]).to eq('User not found')
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

    it 'renders all existing users' do
      create_list(:user, 3)
      get :index
      expect(response.body).to include(*User.all.map(&:name))
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

    it 'renders a form to create a new user' do
      expect(response.body).to include('form', 'New user', 'Create User')
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      let(:valid_params) { { user: attributes_for(:user) } }

      before { post :create, params: valid_params }

      it 'redirects to the show page' do
        expect(response).to redirect_to(user_path(User.last))
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('User was successfully created.')
      end

      it 'creates a new user' do
        expect { post :create, params: valid_params }.to change(User, :count).by(1)
      end

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: attributes_for(:user, name: nil) } }

      before { post :create, params: invalid_params }

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end

      it 'does not create a new user' do
        expect { post :create, params: invalid_params }.not_to change(User, :count)
      end

      it 'returns an unprocessable entity http status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the user errors' do
        expect(response.body).to include(CGI.escapeHTML("Name can't be blank"))
      end
    end
  end

  describe '#edit' do
    context 'when the user exists' do
      let(:user) { create(:user) }

      before { get :edit, params: { id: user.id } }

      it 'returns a ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'renders a form to edit the user' do
        expect(response.body).to include('form', 'Editing user', 'Update User')
      end
    end

    context 'when the user does not exist' do
      before { get :edit, params: { id: 0 } }

      it_behaves_like 'user not found'
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      let(:user) { create(:user) }

      before { put :update, params: { id: user.id, user: { name: 'New name' } } }

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to the show page' do
        expect(response).to redirect_to(user_path(user))
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('User was successfully updated.')
      end

      it 'updates the user name' do
        user.reload
        expect(user).to have_attributes(name: 'New name')
      end
    end

    context 'with invalid parameters' do
      let(:user) { create(:user) }

      before { put :update, params: { id: user.id, user: { name: nil } } }

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'does not update the user' do
        user.reload
        expect(user).not_to have_attributes(name: nil)
      end

      it 'returns an unprocessable entity http status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the user errors' do
        expect(response.body).to include(CGI.escapeHTML("Name can't be blank"))
      end
    end
  end

  describe '#show' do
    context 'when the user exists' do
      let(:user) { create(:user) }

      before { get :show, params: { id: user.id } }

      it 'returns a ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end

      it 'renders the received user and its details' do
        expect(response.body).to include(user.name, user.status)
      end
    end

    context 'when the user does not exist' do
      before { get :show, params: { id: 0 } }

      it_behaves_like 'user not found'
    end
  end

  describe '#destroy' do
    context 'when the user exists' do
      let(:user) { create(:user) }

      before { delete :destroy, params: { id: user.id } }

      it 'redirects to the users index' do
        expect(response).to redirect_to(users_path)
      end

      it 'returns a redirection http status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'sets a flash notice message' do
        expect(flash[:notice]).to eq('User was successfully destroyed.')
      end
    end

    context 'when the user does not exist' do
      before { delete :destroy, params: { id: 0 } }

      it_behaves_like 'user not found'
    end
  end
end
