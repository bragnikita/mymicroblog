# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  username   :string(255)      not null
#  password   :string(255)      not null
#  email      :string(255)
#  admin      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord

  def self.admin_id
    User.admin.id
  end

  def self.admin
    User.find_by!(:admin => true)
  end
end
