FactoryBot.define do
  factory :post do
    title {Faker::Book.title}
    excerpt {Faker::Lorem.paragraph_by_chars(256)}
    slug {Faker::Internet.slug(title).gsub('.','_')}
    published_at {Faker::Date.backward(10)}
    post_type { 'blogpost' }
    association :owner, factory: :admin

    transient do
      with_no_content { false }
      content_format {'html'}
      content { Faker::Lorem.paragraphs(5) }
    end

    after(:create) do |post, eval|
      unless eval.with_no_content
        create(:post_content, post: post, role: 'main', content_format: eval.content_format, content: eval.content)
      end
    end

  end
end