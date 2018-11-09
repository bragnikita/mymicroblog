class Image < ApplicationRecord

  mount_uploader :link, ImagesUploader

  belongs_to :uploaded_by, class_name: "User", optional: true
  belongs_to :folder, class_name: 'Folder', optional: true

end