require 'rails_helper'

RSpec.describe 'PostsController', type: :request do

  describe 'index' do

    it 'displays the page on /posts' do
      get '/posts'

      expect(response).to have_http_status(200)
    end
  end

  describe 'edit' do
    it 'displays the page on /posts/new' do
      get '/posts/new'

      expect(response).to have_http_status(200)
    end
  end

end