require 'rails_helper'

RSpec.describe 'PostsController', type: :request do

  context 'pages smoke test' do
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

    describe 'when we want to view the post' do
      before {
        attrs = attributes_for(:post, :slug => 'my_first_post',
                               :title => 'My first post')
        Operations::AddPost.new(attrs).call
        get '/p/my_first_post'
      }
      it 'displays the post' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'when the post is not exists' do

    end
  end
end