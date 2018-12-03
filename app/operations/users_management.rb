require 'simple_command'
require "#{Rails.root}/lib/json_web_token"
module UsersManagement
class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
    @user = nil
    self
  end

  def call
    @user = get_user
    JsonWebToken::encode(user_id: @user.id) if @user
  end

  private

  attr_accessor :email, :password

  def get_user
    user = User.find_by_email(email)
    return user if user && user.authenticate(password)
    errors.add(:user_authentication, 'invalid credentials')
    nil
  end
end

class AuthorizeRequest
  prepend SimpleCommand
  attr_reader :token, :user

  def initialize(token)
    @token = token
    self
  end

  def call
    fetch_user
    self
  end

  private

  def fetch_user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(token)
  end

end
end