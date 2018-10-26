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

  context 'post update api test (/post/:id/update)' do
    describe 'when we updates post with text' do
      let(:attrs_to_update) {
        {
          title: 'Updated title',
          text: 'updated source text'
        }
      }
      let!(:model) {
        Operations::AddPost.new(
          attributes_for(:post,
                         :title => 'Old title',
                         :content => 'old source text'
          )).call!.result.post
      }
      before {
        post "/post/#{model.id}/update", xhr: true, params: {
          title: attrs_to_update[:title],
          contents: {
            main: attrs_to_update[:text],
          }
        }
      }
      it "responses with OK" do
        expect(response).to have_http_status(200)
      end
      it "updates post's attributes" do
        updated_post = Post.find(model.id)

        expect(updated_post.title).to eq(attrs_to_update[:title])
        expect(updated_post.source_content).to eq(attrs_to_update[:text])
        expect(updated_post.filtered_content).to eq(attrs_to_update[:text])
      end

    end

    describe 'when we calls is with non-existed id' do
      it "returns 404"
    end
  end
end