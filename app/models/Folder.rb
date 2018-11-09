class Folder < ApplicationRecord

  belongs_to :owner, class_name: "User", optional: false
  validates :name, uniqueness: {scope: :owner, case_sensitive: false}
  has_many :images, class_name: 'Image', dependent: :destroy, foreign_key: 'folder_id'

end