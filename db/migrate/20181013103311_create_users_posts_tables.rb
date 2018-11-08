class CreateUsersPostsTables < ActiveRecord::Migration[5.2]

  def database_options
    "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci"
  end

  def up
    clear

    create_table :users, options: database_options do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :email
      t.boolean :admin, default: false
      t.timestamps
    end

    create_table :posts, options: database_options do |t|
      t.string :title
      t.text :excerpt
      t.string :slug
      t.datetime :published_at
      t.string :post_type
      t.references :owner, foreign_key: {to_table: :users, on_delete: :restrict}, null: false, index: true
      t.timestamps
    end

    create_table :post_contents, options: database_options do |t|
      t.text :content
      t.text :filtered_content
      t.string :role
      t.string :content_format
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
