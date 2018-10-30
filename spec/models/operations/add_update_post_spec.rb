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


RSpec.describe Operations::UpdatePost, type: :model do
  context 'when all parameters are specified' do

    let(:orig_post) {
      create(:post)
    }
    let(:new_attrubutes) {
      {
        title: 'new title',
        slug: '/new_slug',
        excerpt: 'some excerpt',
        source_filter: 'markdown',
        contents: {
          main: 'some html contents'
        }
      }
    }

    describe "when all parameters are correct" do

      let(:operation) {
        Operations::UpdatePost.new.from_params(new_attrubutes.merge({id: orig_post.id}))
      }
      before {
        operation.call!
      }

      it 'will update the post' do
        reloaded_post = Post.find(orig_post.id)
        expect(reloaded_post.title).to eq(new_attrubutes[:title])
        expect(reloaded_post.slug).to eq(new_attrubutes[:slug])
        expect(reloaded_post.excerpt).to eq(new_attrubutes[:excerpt])
        expect(reloaded_post.source_filter).to eq(new_attrubutes[:source_filter])
        expect(reloaded_post.source_content).to eq(new_attrubutes[:contents][:main])
        expect(reloaded_post.filtered_content).to eq(new_attrubutes[:contents][:main])
      end

      it 'will return correct result' do
        expect {operation.result}.not_to raise_error
        expect(operation.result).to be_ok
        expect(operation.result).not_to be_failed
        expect(operation.result.model).not_to be_nil
        expect(operation.result.model.id).to eq(orig_post.id)
      end
    end

    describe "when original post is not exists" do
      let(:operation) {
        Operations::UpdatePost.new.from_params(new_attrubutes.merge({id: orig_post.id + 1}))
      }
      it 'will raise error' do
        expect {operation.call!}.to raise_error(ActiveRecord::RecordNotFound)
        expect(operation.result).not_to be_nil
        expect(operation.result).to be_failed
      end
      it 'will return error' do
        expect {operation.call}.not_to raise_error
        expect {operation.result}.not_to raise_error
        expect(operation.result).not_to be_ok
        expect(operation.result).to be_failed
        expect(operation.result.error[:message]).not_to be_empty
      end
    end
  end
end