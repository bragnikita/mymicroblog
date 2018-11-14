require 'rails_helper'

RSpec.describe 'FoldersController', type: :request do
  describe '/folders' do
    let!(:folders) do
      create_list(:folder, 3)
    end

    it 'should list 3 folders' do
      get '/folders', xhr: true

      expect(get_body).to include(list: all(include(:id, :name)))
      expect(get_body[:list]).to have(3).items
    end

  end

  describe 'PUT /folders' do
    let(:attributes) do
      attributes_for(:folder).except(:id)
    end

    it 'should create new folder' do
      put '/folders', xhr: true, params: {folder: attributes}

      expect(response).to have_http_status(200)
      expect(get_body).to include(:object => include(:id => anything, :name => attributes[:name]))
    end
  end

  describe 'POST /folder' do
    before(:context) do
      @folder = create(:folder, name: 'myfolder')
    end
    it 'should update folder name' do
      post "/folder/#{@folder.id}", xhr: true, params: {folder: {name: 'newfolder'}}

      expect(response).to have_http_status(:success)
      expect(Folder.find(@folder.id)).to have_attributes(:name =>'newfolder')
    end
  end

  describe 'DELETE /folder' do
    before(:context) do
      @folder = create(:folder)
      delete "/folder/#{@folder.id}", xhr: true
    end
    it 'should return success' do
      expect(response).to have_http_status(:success)
    end
    it 'folder must be deleted' do
      expect(Folder.exists?(@folder.id)).to be_falsey
    end
  end
end