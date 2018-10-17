FactoryBot.define do
  factory :post do
    title {Faker::Book.title}
    excerpt {Faker::Lorem.paragraph_by_chars(256)}
    slug {Faker::Internet.slug(title).gsub('.','_')}
    published_at {Faker::Date.backward(10)}
    source_filter {'html'}
    association :owner, factory: :admin

    transient do
      with_no_content { false }
      content { Faker::Lorem.paragraphs(5) }
    end

    after(:create) do |post, eval|
      unless eval.with_no_content
        create(:post_content, post: post, type: 'source', content: eval.content)
        create(:post_content, post: post, type: 'filtered', content: eval.content)
      end
    end

  end
end