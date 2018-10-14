class PostsController < ApplicationController

  def index

    render 'index'
  end

  def new

    render 'edit'
  end
end