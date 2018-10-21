class PostsController < ApplicationController

  def index

    render 'index'
  end

  def new

    render 'edit'
  end

  def create
    slug = params[:slug]
    Operations::AddPost.new({
                              title: params[:title],
                              content: params[:content],
                              excerpt: params[:excerpt],
                              slug: params[:slug],
                              published_at: Time.now
                            }).call
    if request.xhr?
      render json: {
        result: 0,
        redirect_to: "/p/#{slug}"
      }
    else
      redirect_to "/p/#{slug}"
    end
  end

  def display
    @post = ViewModel.new(Post.by_slug(params[:slug]))
    render 'display'
  end

  class ViewModel
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def text
      @post.filtered_content
    end

    def title
      @post.title
    end
  end
end
