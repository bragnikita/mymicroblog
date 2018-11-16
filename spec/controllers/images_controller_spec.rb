require 'rails_helper'

RSpec.describe 'ImagesController', type: :request do

  context 'pages smoke test' do
    describe 'index' do

      it 'displays the page on /images' do
        get '/images'
        expect(response).to have_http_status(200)
      end
    end

  end

  context 'image add api test (PUT /images)' do
    describe 'when we uploads image' do
      before(:context) {
        @file = fixture_file_upload('images/common.jpg', 'image/jpg')
        @folder = create(:folder)

        put '/images', params: {image: {link: @file, folder_id: @folder.id}}
      }
      it "responses with OK" do
        expect(response).to have_http_status(200)
      end
      it "json response is correct" do
        expect(get_body).to include(
                              :result => 0,
                              :object => a_hash_including(
                                           :id => anything,
                                           :url => kind_of(String),
                                           :title => anything,
                                           :folder_id => @folder.id,
                                           :folder_name => @folder.name,
                                           :folder_title => @folder.title
                              )
                            )
      end

    end
  end
end