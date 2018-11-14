FactoryBot.define do
  factory :user do
    username {Faker::Internet.unique.username(8)}
    password {Faker::Internet.password(8)}
    email {Faker::Internet.free_email(username)}
    admin {false}
  end
  factory :admin, class: User do
    initialize_with do
      User.find_or_create_by(
        :admin => true,
        :username => 'admin',
        :password => '1234',
        :email => 'admin@myblog.org',
      )
    end
  end
end