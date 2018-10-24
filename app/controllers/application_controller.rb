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
end
