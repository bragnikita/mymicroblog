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

class Post < ApplicationRecord

  belongs_to :owner, class_name: "User", optional: false
  has_many :contents, class_name: "PostContent"

  def self.by_slug(slug)
    Post.find_by!(:slug => slug)
  end

  def self.total_index(filter = {})
    page_number = filter.fetch(:page, 1)
    limit = filter.fetch(:limit, 100)
    Post.order(:published_at => :desc, :updated_at => :desc).page(page_number).per(limit)
  end

  def main_content
    self.contents.find_by!(:role => 'main')
  end

  def main_content_text
    self.main_content.content
  end

  def main_content_filtered_text
    self.main_content.filtered_content
  end

  def content_for_or_create!(role)
    PostContent.first_or_create!(post: self, role: role)
  end

  def contents_for(roles)
    in_roles = roles
    unless roles.kind_of?(Array)
      in_roles = [roles]
    end
    in_roles.empty? ? contents : contents.where(role: in_roles)
  end
end
