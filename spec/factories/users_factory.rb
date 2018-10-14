FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(8) }
    password { Faker::Internet.password(8) }
    email { Faker::Internet.free_email(username) }
    admin { false }
    factory :admin do
      admin { true }
    end
  end

end