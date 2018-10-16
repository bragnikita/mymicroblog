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

class PostContent < ApplicationRecord
  PostContent.inheritance_column = 'object_type'

  belongs_to :post, class_name: "Post", optional: false
end
