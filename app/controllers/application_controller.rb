class ApplicationController < ActionController::Base

  before_action :setup_page_view_model

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

  def current_user
    User.admin
  end

  private

  def render_not_found(e)
    render status: :not_found, json: {
      result: 1,
      message: "requested object #{e.model} with id #{e.id} was not found"
    }
  end
end
