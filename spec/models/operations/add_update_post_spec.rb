require 'rails_helper'

RSpec.describe Operations::AddPost, type: :model do

  describe 'when all parameters specified' do
    let(:text) {'some text '}
    let(:attrs) {
      content_attrs = attributes_for(:post_content, content: text)
      attributes_for(:post).merge({
                                    contents: {
                                      main: content_attrs.slice(:content, :content_format)
                                    }
                                  })
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
      expect(reloaded_post.contents).to have(1).items
      expect(reloaded_post.contents.map(&:role)).to contain_exactly('main')
      expect(reloaded_post.contents.first.content).to eq(text)
    end

    describe 'when no contents specified' do
      let(:attrs) {
        attributes_for(:post)
      }
      it 'returns correct result' do
        expect {operation}.not_to raise_error
        expect(operation.result.ok?).to be_truthy
        expect(operation.result.error?).to be_falsey
        expect(operation.result.post).to be_an_instance_of Post
      end
      it 'has 1 main content' do
        expect(reloaded_post.contents).to have(1).items
        expect(reloaded_post.contents.map(&:role)).to contain_exactly('main')
        expect(reloaded_post.contents.first.content).to be_falsey
      end
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

  describe 'when has transformer' do
    let(:user) {
      User.admin
    }
    before(:each) do
      @chain = double(Libs::ContentTransformers::TransformersChain, :call => 'After transformation')
      @transformer =  double(Libs::ContentTransformers::TransformerChainFactory, :create => @chain)
    end
    let!(:operation) {
      op = Operations::AddPost.new(attributes_for(:post)
                                     .merge(
                                       {
                                         contents: {main: {
                                           content_format: 'markdown',
                                           content: 'Before transformation'
                                         }}}
                                     ))
      op.transformations = @transformer
      op.call
    }
    it 'should call transformer factory with "markdown" request' do
      expect(@transformer).to receive(:create).with('markdown')
      # expect(@chain).to receive(:call).with('Before transformation')
    end
    it 'should save "After transformation"' do
      expect(operation.result.post.main_content_filtered_text).to eq('After transformation')
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
        post_type: 'blogpost',
        contents: {
          main: {
            content_format: 'plain',
            content: 'some plain contents',
          }
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
        expect(reloaded_post.post_type).to eq(new_attrubutes[:post_type])
        expect(reloaded_post.main_content_text).to eq(new_attrubutes[:contents][:main][:content])
        expect(reloaded_post.main_content.filtered_content).to eq(new_attrubutes[:contents][:main][:content])
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