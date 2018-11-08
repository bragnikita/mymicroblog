# == Schema Information
#
# Table name: posts
#
#  id           :bigint(8)        not null, primary key
#  excerpt      :text(65535)
#  post_type    :string(255)
#  published_at :datetime
#  slug         :string(255)
#  title        :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :bigint(8)        not null
#
# Indexes
#
#  index_posts_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

require 'rails_helper'

RSpec.describe 'Post', type: :model, with_empty_db: true  do

  describe "CRUD" do
    let(:post) { create(:post, with_no_content: true) }
    let(:post_with_contents) {
      create_list(:post_content, 2, post: post)
      post
    }

    it "must save new post in database" do
      expect { post }.to_not raise_error
    end

    it "must fetch 2 post contents" do
      contents = post_with_contents.reload.contents
      expect(contents).to have(2).items
    end

  end

  context "helpers" do
    let(:content) { 'some text '}
    let(:post) { create(:post, content: content)}
    describe "main_content" do
      it "returns main content" do
        expect(post.main_content).to be_kind_of(PostContent)
        expect(post.main_content.role).to eq("main")
      end
    end
    describe "main_content_text" do
      it "returns main content text" do
        expect(post.main_content_text).to eq(content)
      end
    end
  end

  context "finders" do
    context "listing" do
      describe "total listing", :keep_data => true do
        before do
          order = 1
          while order <= 10 do
            create(:post, title: "post #{order}", published_at: Date.today + order )
            order += 1
          end
        end
        let(:total_index) do
          Post.total_index(:page => 2, :limit => 4)
        end
        it "should be sorted" do
          expect(total_index).to be_ordered_by "published_at_desc"
        end
        it "should be limited to 4" do
          expect(total_index.count).to eq(4)
        end
        it "should be 2th page" do
          expect(total_index[0].title).to eq('post 6')
          expect(total_index[1].title).to eq('post 5')
          expect(total_index[2].title).to eq('post 4')
          expect(total_index[3].title).to eq('post 3')
        end
      end
    end
  end

end
