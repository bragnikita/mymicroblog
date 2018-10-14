# == Schema Information
#
# Table name: post_contents
#
#  id         :bigint(8)        not null, primary key
#  content    :text(65535)
#  type       :string(255)
#  post_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe 'PostContent', type: :model do

  describe "CRUD" do
    let(:content) { create(:post_content) }

    it "must save content model" do
      expect { content }.to_not raise_error
    end

  end
end
