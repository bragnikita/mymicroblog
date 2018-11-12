# == Schema Information
#
# Table name: folders
#
#  id       :bigint(8)        not null, primary key
#  name     :string(255)      not null
#  title    :string(255)
#  owner_id :bigint(8)        not null
#
# Indexes
#
#  index_folders_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id) ON DELETE => cascade
#

class Folder < ApplicationRecord

  belongs_to :owner, class_name: "User", optional: false
  validates :name, uniqueness: {scope: :owner, case_sensitive: false}
  has_many :images, class_name: 'Image', dependent: :destroy, foreign_key: 'folder_id'

end
