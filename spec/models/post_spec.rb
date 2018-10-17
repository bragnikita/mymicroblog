# == Schema Information
#
# Table name: posts
#
#  id            :bigint(8)        not null, primary key
#  excerpt       :text(65535)
#  published_at  :datetime
#  slug          :string(255)
#  source_filter :string(255)
#  title         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint(8)        not null
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

end
