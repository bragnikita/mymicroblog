class ComponentsTestController < ApplicationController
  layout 'test'

  def open_component
    render 'display_page'
  end
end