require 'rails_helper'

RSpec.describe 'Image', type: :model do
  describe "CRUD" do
    let(:image) { create(:image) }

    it "must save new image in the database" do
      expect { image }.to_not raise_error
      expect(image).to be_valid
    end

    it "an associated folder must be accessible" do
      expect(image.folder).to be_present
    end
    it "must have an uploader" do
      expect(image.uploaded_by).to be_present
    end
  end

end

RSpec.describe 'Folder', type: :model do
  describe 'CRUD' do
    let(:folder) do
      create(:folder)
    end
    let!(:images) do
      create_list(:image, 2, folder: folder)
    end

    it "must create folder" do
      expect { folder }.to_not raise_error
      expect(folder.images).to have(2).items
      expect(folder.owner).to be_present
    end

    it "must delete images when folder is destroyed" do
      expect(folder.images).to have(2).items
      result = folder.destroy
      expect(result).to be_truthy
      expect(Image.where("folder_id = #{folder.id}").count).to be_zero
    end
  end
end