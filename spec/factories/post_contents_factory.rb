FactoryBot.define do
  factory :post_content do
    content { Faker::Lorem.paragraphs(5)}
    type { 'source' }
    association :post, factory: :post
  end

end