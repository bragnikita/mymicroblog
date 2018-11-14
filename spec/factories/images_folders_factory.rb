FactoryBot.define do
  factory :folder, class: Folder do
    title {Faker::Music.album}
    name {Faker::Lorem.unique.word.downcase}
    association :owner, factory: :admin
  end

end

FactoryBot.define do
  factory :image do
    link do
      File.open(Rails.root.join('spec', 'fixtures', 'images', image_path))
    end
    transient do
      image_path { 'common.jpg' }
    end
    title {Faker::Pokemon.name}
    association :folder, factory: :folder
    after(:build) do |image, eval|
      unless eval.uploaded_by.nil?
        return
      end
      if User.admin.present?
        image.uploaded_by = User.admin
      else
        image.uploaded_by = build(:admin)
      end
    end
  end

end