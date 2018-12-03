# == Schema Information
#
# Table name: users
#
#  id                    :bigint(8)        not null, primary key
#  admin                 :boolean          default(FALSE)
#  email                 :string(255)
#  password_confirmation :string(255)
#  password_digest       :string(255)
#  username              :string(255)      not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class User < ApplicationRecord
  has_secure_password

  def self.admin_id
    User.admin.id
  end

  def self.admin
    User.find_by!(:admin => true)
  end

  def is_admin?
    self.admin
  end
end
