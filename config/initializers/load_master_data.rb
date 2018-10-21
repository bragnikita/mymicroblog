Rails.application.config.after_initialize do
  if Rails.env.development?
    ActiveSupport.on_load(:active_record) do
      if ActiveRecord::Base.connection.table_exists? 'users'
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
  end

end