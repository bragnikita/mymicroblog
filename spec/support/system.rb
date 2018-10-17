RSpec.configure do | config |
  config.before(:each, :type => :system) do
    driven_by :rack_test
  end
  config.before(:each, :type => :system, :process_js => true) do
    driven_by :selenium
  end
end