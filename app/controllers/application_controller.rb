class ApplicationController < ActionController::Base

  before_action :setup_page_view_model, if: lambda {!request.xhr?}
  before_action :authenticate

  def page
    @page
  end

  private

  def setup_page_view_model
    @page = PageViewModel.new
  end

  class PageViewModel
    attr_accessor :title
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ApiErrors::AccessForbidden, :with => :render_access_forbidden
  rescue_from ApiErrors::AuthorizationRequired, :with => :redirect_to_login

  def current_user
    @user ||= authenticate
  end

  def authenticated?
    current_user.present?
  end

  def access_admin
    fail ApiErrors::AuthorizationRequired unless authenticated?
    fail ApiErrors::AccessForbidden unless current_user.is_admin?
  end

  def access_all

  end

  def access_authenticated
    fail ApiErrors::AuthorizationRequired unless authenticated?
  end

  private

  def render_not_found(e)
    render status: :not_found, json: {
      result: 1,
      message: "requested object #{e.model} with id #{e.id} was not found"
    }
  end

  def render_access_forbidden(e)
    status = authenticated? ? :forbidden : :unauthorized
    if request.xhr?
      head status
    else
      render :file => 'public/422.html', status: status
    end
  end

  def redirect_to_login
    session[:return_to] = request.fullpath
    if request.xhr?
      head :unauthorized
    else
      redirect_to '/login'
    end
  end

  def authenticate
    # if request.xhr?
    #   @user = authorize_xhr
    # else
    #   @user = authorize_page_access
    # end
    authorize_page_access
  end

  def authorize_page_access
    token = request.cookies['access_token']
    return nil if token.nil?
    UsersManagement::AuthorizeRequest.new(token).call.user
  end

  def authorize_xhr
    return nil if request.headers['Authorization'].nil?
    token = request.headers['Authorization'].split.last
    UsersManagement::AuthorizeRequest.new(token).call.user
  end
end

