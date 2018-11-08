# == Schema Information
#
# Table name: post_contents
#
#  id               :bigint(8)        not null, primary key
#  content          :text(65535)
#  content_format   :string(255)
#  filtered_content :text(65535)
#  role             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  post_id          :bigint(8)        not null
#
# Indexes
#
#  index_post_contents_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id) ON DELETE => cascade
#

require 'rails_helper'

RSpec.describe 'PostContent', type: :model, with_empty_db: true do

  describe "CRUD" do
    let(:content) { create(:post_content) }

    it "must save content model" do
      expect { content }.to_not raise_error
    end

  end
end
