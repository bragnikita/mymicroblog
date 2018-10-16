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

class Post < ApplicationRecord

  belongs_to :owner, class_name: "User", optional: false
  has_many :contents, class_name: "PostContent"

  def self.by_slug(slug)
    Post.find_by!(:slug => slug)
  end

  def filtered_content
    self.contents.find_by!(:type => 'filtered').content
  end
end
