class CreateUsersPostsTables < ActiveRecord::Migration[5.2]
  def up
    clear

    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :email
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :posts do |t|
      t.string :title
      t.text :excerpt
      t.string :slug
      t.datetime :published_at
      t.string :source_filter
      t.references :owner, foreign_key: {to_table: :users, on_delete: :restrict}, null: false, index: true
      t.timestamps
    end

    create_table :post_contents do |t|
      t.text :content
      t.string :type
      t.references :post, foreign_key: {to_table: :posts, on_delete: :cascade}, null: false, index: true
      t.timestamps
    end
  end

  def down
    clear
  end

  def clear
    drop_table :post_contents if table_exists? :post_contents
    drop_table :posts if table_exists? :posts
    drop_table :users if table_exists? :users
  end
end
