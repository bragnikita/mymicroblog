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

class Post < ApplicationRecord

  belongs_to :owner, class_name: "User", optional: false
  has_many :contents, class_name: "PostContent"

  def self.by_slug(slug)
    Post.find_by!(:slug => slug)
  end

  def source_content_obj
    self.contents.find_by!(:type => 'source')
  end

  def filtered_content_obj
    self.contents.find_by!(:type => 'filtered')
  end

  def filtered_content
    self.filtered_content_obj.content
  end

  def source_content
    self.source_content_obj.content
  end
end
