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

end
