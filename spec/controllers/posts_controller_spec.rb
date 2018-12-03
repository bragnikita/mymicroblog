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
        AddPost.new(attrs).call
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
    let(:attrs_to_update) {
      {
        title: 'Updated title',
        text: 'updated source text'
      }
    }
    let!(:model) {
      AddPost.new(
        attributes_for(:post,
                       :title => 'Old title',
                       :contents => { main: { content: 'old source text' } }
        )).call!.result.post
    }
    describe 'when we updates post with text' do
      before {
        post "/post/#{model.id}/update", xhr: true, params: {
          title: attrs_to_update[:title],
          contents: {
            main: { content: attrs_to_update[:text] },
          }
        }
      }
      it "responses with OK" do
        expect(response).to have_http_status(200)
      end
      it "updates post's attributes" do
        updated_post = Post.find(model.id)

        expect(updated_post.title).to eq(attrs_to_update[:title])
        expect(updated_post.main_content_text).to eq(attrs_to_update[:text])
        expect(updated_post.main_content_filtered_text).to eq(attrs_to_update[:text])
      end

    end

    describe 'when we calls is with non-existed id' do
      before {
        post "/post/#{model.id + 1}/update", xhr: true, params: {
          title: attrs_to_update[:title],
          contents: {
            main: attrs_to_update[:text],
          }
        }
      }
      it "returns 404" do
        expect(response).to have_http_status(404)
        expected = {
          result: 1,
          message: match("requested object Post with id #{model.id + 1} was not found")
        }
        expect(get_body).to include(expected)
      end
    end
  end
end