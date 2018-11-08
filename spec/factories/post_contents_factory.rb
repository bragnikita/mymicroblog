FactoryBot.define do
  factory :post_content do
    content { Faker::Lorem.paragraphs(5)}
    role { 'main' }
    content_format { 'html' }
    filtered_content { content }
    association :post, factory: :post
  end

end