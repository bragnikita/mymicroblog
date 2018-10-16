require 'rails_helper'

RSpec.describe Operations::AddPost, type: :model do

  describe 'when all parameters specified' do
    let(:attrs) {
      attributes_for(:post).merge(attributes_for(:post_content).slice(:content))
    }
    let(:user) {
      create(:user)
    }
    let(:operation) {
      Operations::AddPost.new(attrs.merge(:user_id => user.id)).call
    }
    let(:reloaded_post) {
      Post.find(operation.result.post.id)
    }
    it 'returns correct result' do
      expect {operation}.not_to raise_error
      expect(operation.result.ok?).to be_truthy
      expect(operation.result.error?).to be_falsey
      expect(operation.result.post).to be_an_instance_of Post
    end
    it 'creates new post' do
      expect(reloaded_post.title).to eq(attrs[:title])
      expect(reloaded_post.contents).to have(2).items
      expect(reloaded_post.contents.map(&:type)).to contain_exactly('source', 'filtered')
      expect(reloaded_post.contents.map(&:content)).to all(not_blank)
    end
  end

  describe 'when user is not specified' do
    let(:user) {
      User.admin
    }
    let(:operation) {
      Operations::AddPost.new(attributes_for(:post)).call
    }
    it 'creates user with default admin user' do
      expect(operation.result.post.owner).to eq(user)
    end
  end
end
