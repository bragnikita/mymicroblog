if Rails.env.development?
  ActiveSupport.on_load(:active_record) do
    unless User.exists?(:admin => true)
      User.create!({
                     username: 'admin',
                     admin: true,
                     email: 'mail@mail.com',
                     password: '12345',
                   })
    end
  end
end