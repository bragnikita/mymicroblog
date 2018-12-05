require 'rails_helper'

RSpec.describe AuthController, type: :controller do

  def email
    'aaaa@bbbb.com'
  end

  def password
    '1234567890'
  end

  describe 'when return_to is specified' do
    before do
      create(:user, email: email, password: password, admin: true)
      post :create, params: {user: {login_id: email, password: password}}, xhr: xhr, session: {return_to: '/auth/test?role=admin'}
    end
    describe 'xhr request' do
      let(:xhr) {true}
      it 'returns redirect_to parameter' do
        expect(response).to have_http_status 200
        expect(get_body).to include({:redirect_to => "/auth/test?role=admin"})
      end
    end
    describe 'page request' do
      let(:xhr) {false}
      it 'redirects to return_to location' do
        expect(response).to have_http_status 302
        expect(response.get_header('Location')).to has_path('/auth/test')
        expect(response.get_header('Location')).to has_query({:role => 'admin'})
      end
    end
  end
end

RSpec.describe 'Auth Requests', type: :request do
  # tests AuthController
  def email
    'aaaa@bbbb.com'
  end

  def password
    '1234567890'
  end

  describe 'Access the resource' do
    before do
      create(:user, email: email, password: password, admin: true)
      cookies[:access_token] = UsersManagement::AuthenticateUser.call(email, password).result
    end

    describe 'when accessing as admin' do
      before {get '/auth/test?role=admin'}
      it('allows access') {expect(response).to have_http_status(:ok)}
    end
    describe 'when accessing as any user' do
      before {get '/auth/test?role=authenticated'}
      it('allows access') {expect(response).to have_http_status(:ok)}
    end
    describe 'when accessing as anonymous' do
      before {get '/auth/test'}
      it('allows access') {expect(response).to have_http_status(:ok)}
    end
  end

  describe 'when access is restricted' do
    before do
      create(:user, email: email, password: password)
      cookies[:access_token] = UsersManagement::AuthenticateUser.call(email, password).result
    end
    describe 'when accessing as any user' do
      before {get '/auth/test?role=admin'}
      it('restricts access') {expect(response).to have_http_status(:forbidden)}
    end
    describe 'when accessing admin area as any anonymous' do
      describe 'and ajax' do
        before {cookies[:access_token] = nil; get '/auth/test?role=admin', xhr: true}
        it('restricts access') {expect(response).to have_http_status(:unauthorized)}
      end
      describe 'and page request' do
        before {cookies[:access_token] = nil; get '/auth/test?role=admin', xhr: false}
        it('redirects to login') do
          expect(response).to have_http_status(302)
          expect(response.get_header('Location')).to has_path('/login')
        end
      end
    end
  end

  describe 'Signing in' do
    before do
      create(:user, email: email, password: password, admin: true)
    end
    describe 'when credentials are correct' do
      before do
        post '/auth', params: {user: {login_id: email, password: password}}, xhr: true
      end
      let(:token) {cookies[:access_token]}

      it('returns ok') {expect(response).to have_http_status :ok}
      it('has access token') {expect(token).to be_present}
      it('has useable token') do
        expect(UsersManagement::AuthorizeRequest.call(token)).to be_success
      end
    end

    describe 'when return_to is specified' do
      before do
        get '/auth/test?role=admin'
        post '/auth', params: {user: {login_id: email, password: password}}, xhr: xhr
      end
      describe 'xhr request' do
        let(:xhr) {true}
        it 'returns redirect_to parameter' do
          expect(response).to have_http_status 200
          expect(get_body).to include({:redirect_to => "/auth/test?role=admin"})
        end
      end
      describe 'page request' do
        let(:xhr) {false}
        it 'redirects to return_to location' do
          expect(response).to have_http_status 302
          expect(response.get_header('Location')).to has_path('/auth/test')
          expect(response.get_header('Location')).to has_query({:role => 'admin'})
        end
      end
    end

    describe 'when credentials are incorrect' do
      before do
        post '/auth', params: {user: {login_id: email, password: 'not_matching_password'}}
      end
      let(:token) {cookies[:access_token]}

      it('returns 401') {expect(response).to have_http_status :unauthorized}
      it('there is no access token') {expect(token).not_to be_present}
    end
    describe 'when already authenticated' do
      before do
        post '/auth', params: {user: {login_id: email, password: password}}
      end
      let(:token) {cookies[:access_token]}

      it('returns ok') do
        post '/auth', params: {user: {login_id: email, password: password}}
        expect(response).to have_http_status :ok
      end
      it('access token was not changed') do
        old_token = cookies[:access_token]
        post '/auth', params: {user: {login_id: email, password: password}}
        expect(cookies[:access_token]).to eq(old_token)
      end
    end
  end

  describe 'Sign out' do
    let(:token) {cookies[:access_token]}
    describe 'when signed in' do
      before do
        post '/auth', params: {user: {login_id: email, password: password}}
      end
      it 'removes cookie' do
        get '/logout'
        expect(response).to have_http_status :ok
        expect(token).not_to be_present
      end
    end
    describe 'when signed out' do
      it 'do nothing' do
        expect(token).not_to be_present
        get '/logout'
        expect(response).to have_http_status :ok
        expect(token).not_to be_present
      end
    end

  end


end