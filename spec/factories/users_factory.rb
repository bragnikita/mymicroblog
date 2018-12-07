FactoryBot.define do
  factory :user do
    username {Faker::Internet.unique.username(8)}
    password {Faker::Internet.password(8)}
    email {Faker::Internet.free_email(username)}
    admin {false}
  end
  factory :admin, class: User do
    initialize_with do
      user = User.find_or_create_by(
        :admin => true,
        :username => 'admin',
        :email => 'admin@myblog.org',
      )
      user.password = '12345'
      user.save
      user
    end
  end
  factory :nikita, class: User do
    initialize_with do
      user = User.find_or_create_by(
        :admin => false,
        :username => 'nikita',
        :email => 'nikita@mail.com',
      )
      user.password = 'nikita123'
      user.save
      user
    end
  end
  factory :alex, class: User do
    initialize_with do
      user = User.find_or_create_by(
        :admin => false,
        :username => 'alex',
        :email => 'alex@mail.com',
      )
      user.password = 'alex123'
      user.save
      user
    end
  end
end