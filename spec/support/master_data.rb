def init_db(setup_name)
  if setup_name == :test
    create(:admin)
  elsif setup_name == :diary
    admin = create(:admin)
    create_list(:post, 5, owner_id: admin)
  end
end
