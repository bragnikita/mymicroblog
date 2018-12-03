require 'rails_helper'

RSpec.describe 'Auth Requests', type: :request do
  # tests AuthController

  let(:email) {'aaaa@bbbb.com'}
  let(:password) {'1234567890'}

  describe 'when signing in' do

  end
  describe 'Access the resource' do
    before do
      create(:user, email: email, password: password, admin: true)
      cookies[:access_token] = UsersManagement::AuthenticateUser.call(email, password).result
    end

    describe 'when accessing as admin' do
      before {get '/auth/test?role=admin'}
      it('allows access') { expect(response).to have_http_status(:ok) }
    end
    describe 'when accessing as any user' do
      before {get '/auth/test?role=authenticated'}
      it('allows access') { expect(response).to have_http_status(:ok) }
    end
    describe 'when accessing as anonymous' do
      before {get '/auth/test'}
      it('allows access') { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'when access is restricted' do
    before do
      create(:user, email: email, password: password)
      cookies[:access_token] = UsersManagement::AuthenticateUser.call(email, password).result
    end
    describe 'when accessing as any user' do
      before {get '/auth/test?role=admin'}
      it('restricts access') { expect(response).to have_http_status(:forbidden) }
    end
    describe 'when accessing as any anonymous' do
      before {cookies[:access_token] =nil; get '/auth/test?role=admin'}
      it('restricts access') { expect(response).to have_http_status(:unauthorized) }
    end
  end
end