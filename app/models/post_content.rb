# == Schema Information
#
# Table name: post_contents
#
#  id         :bigint(8)        not null, primary key
#  content    :text(65535)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint(8)        not null
#
# Indexes
#
#  index_post_contents_on_post_id  (post_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id) ON DELETE => cascade
#

class PostContent < ApplicationRecord
  PostContent.inheritance_column = 'object_type'

  belongs_to :post, class_name: "Post", optional: false
end
