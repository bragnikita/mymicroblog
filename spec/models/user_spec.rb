# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  username   :string(255)      not null
#  password   :string(255)      not null
#  email      :string(255)
#  admin      :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe 'User', type: :model do

  describe "CRUD" do
    let(:user) { create(:user) }

    it "must not fail" do
      expect {user}.to_not raise_error
    end

    it "must create valid user" do
      expect(user).to be_valid
    end
    it "must update user's field" do
      new_email = "#{user.username}_update@mail.com"
      user.email = new_email
      user.save
      expect(user).to be_valid
      user.reload
      expect(user.email).to eq(new_email)
    end

  end
end
