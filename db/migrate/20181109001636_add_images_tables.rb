class AddImagesTables < ActiveRecord::Migration[5.2]

  def database_options
    "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci"
  end

  def up
    clear

    create_table :folders, options: database_options do |t|
      t.string :name, null: false
      t.string :title
      t.references :owner, foreign_key: {to_table: :users, on_delete: :cascade}, null: false, index: true
    end

    create_table :images, options: database_options do |t|
      t.string :link, null: false
      t.string :title
      t.references :folder, foreign_key: {to_table: :folders, on_delete: :restrict}, null: true, index: true
      t.references :uploaded_by, foreign_key: {to_table: :users, on_delete: :nullify}, null: true
      t.timestamps
    end
  end

  def down
    clear
  end

  def clear
    drop_table :images if table_exists? :images
    drop_table :folders if table_exists? :folders
  end
end
