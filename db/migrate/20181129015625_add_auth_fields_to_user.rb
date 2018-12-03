class AddAuthFieldsToUser < ActiveRecord::Migration[5.2]
  def up
    change_table 'users' do |t|
      t.remove :password
      t.string :password_digest
      t.string :password_confirmation
    end
  end

  def down
    change_table 'users' do |t|
      t.string :password
      t.remove :password_digest
      t.remove :password_confirmation
    end
  end
end
