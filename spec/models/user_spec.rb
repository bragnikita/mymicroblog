# == Schema Information
#
# Table name: users
#
#  id                    :bigint(8)        not null, primary key
#  admin                 :boolean          default(FALSE)
#  email                 :string(255)
#  password_confirmation :string(255)
#  password_digest       :string(255)
#  username              :string(255)      not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'rails_helper'

RSpec.describe 'User', type: :model, with_empty_db: true do

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

  describe '#authenticate' do
    let(:user) do
      create(:user, email: 'aaa@fff.com', password: '12345')
    end

    it 'authenticates user' do
      expect(user.authenticate('12345')).to eq(user)
    end

    it 'returns false if wrong password provided' do
      expect(user.authenticate('wrong')).to eq(false)
    end

  end
end
