# require '../models/operations/users_management'

class AuthController < ApplicationController
  skip_forgery_protection

  def create
    if authenticated?
      render status: :ok, json: nil and return
    end
    email = auth_params[:login_id]
    password = auth_params[:password]
    cmd = UsersManagement::AuthenticateUser.call(email, password)
    if cmd.success?
      jwt = cmd.result
      set_jwt_cookie jwt
      render status: :ok, json: nil
      # render status: :created, json: {access_token: jwt}
    else
      remove_jwt_cookie
      render status: :ok, json: { message: 'email - password pair does not match any registered user'}
    end
  end

  def test
    role = params[:role]
    access_admin if role == 'admin'
    access_authenticated if role == 'authenticated'
    access_all unless role.present?
    render status: :ok, json: { result: 'passed'}
  end

  private

  def auth_params
    params.require('user').permit('login_id', 'password')
  end

  def set_jwt_cookie(jwt_payload)
    cookies[:access_token] = {
      value: jwt_payload,
      expires: 1.days.from_now,
      secure: Rails.env.production?,
      httponly: true,
    }
  end

  def remove_jwt_cookie
    cookies.delete(:access_token)
  end

end