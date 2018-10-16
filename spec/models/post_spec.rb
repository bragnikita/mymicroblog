# == Schema Information
#
# Table name: posts
#
#  id            :bigint(8)        not null, primary key
#  title         :string(255)
#  excerpt       :text(65535)
#  slug          :string(255)
#  published_at  :datetime
#  source_filter :string(255)
#  owner_id      :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
