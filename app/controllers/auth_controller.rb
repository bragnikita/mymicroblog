# require '../models/operations/users_management'

class AuthController < ApplicationController
  skip_forgery_protection

  def new
    if authenticated?
      redirect_to '/' and return
    end
    render 'sign_in'
  end

  def create
    if authenticated?
      head :ok and return
    end
    email = auth_params[:login_id]
    password = auth_params[:password]
    cmd = UsersManagement::AuthenticateUser.call(email, password)
    if cmd.success?
      jwt = cmd.result
      set_jwt_cookie jwt
      return_to = session[:return_to] || '/'
      session[:return_to] = nil
      if request.xhr?
        render status: :ok, json: {redirect_to: return_to}
      else
        redirect_to return_to
      end
    else
      remove_jwt_cookie
      render status: :unauthorized, json: {message: 'email - password pair does not match any registered user'}
    end
  end

  def destroy
    remove_jwt_cookie if authenticated?
    if request.xhr?
      head :ok
    else
      redirect_to '/login'
    end
  end

  def test
    role = params[:role]
    access_admin if role == 'admin'
    access_authenticated if role == 'authenticated'
    access_all unless role.present?
    render status: :ok, json: {result: 'passed'}
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