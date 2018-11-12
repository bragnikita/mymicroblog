# == Schema Information
#
# Table name: images
#
#  id             :bigint(8)        not null, primary key
#  link           :string(255)      not null
#  title          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  folder_id      :bigint(8)
#  uploaded_by_id :bigint(8)
#
# Indexes
#
#  index_images_on_folder_id       (folder_id)
#  index_images_on_uploaded_by_id  (uploaded_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (uploaded_by_id => users.id) ON DELETE => nullify
#

class Image < ApplicationRecord

  mount_uploader :link, ImagesUploader

  belongs_to :uploaded_by, class_name: "User", optional: true
  belongs_to :folder, class_name: 'Folder', optional: true

end
