class PostsController < ApplicationController

  def index

    render 'index'
  end

  def new
    render 'new'
  end


  def edit
    post = Post.find(params[:id])
    page.title = "[Edit]#{post.title}"
    render 'edit'
  end

  def update
    slug = params[:slug]
    post = Post.find(params[:id])
    post.update!({
                   title: params[:title],
                   excerpt: params[:excerpt],
                   slug: params[:slug],
                 })
    post.source_content_obj.update!({content: params[:content]})
    post.filtered_content_obj.update!({content: params[:content]})
    if request.xhr?
      render json: {
        result: 0,
        redirect_to: "/p/#{slug}"
      }
    else
      redirect_to "/p/#{slug}"
    end
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
    page.title = @post.title
    render 'display', layout: 'layouts/post_display'
  end

  def get
    post = Post.find(params[:id])
    render json: {
      object: {
        id: post.id,
        title: post.title,
        slug: post.slug,
        excerpt: post.excerpt,
        content: post.source_content
      }
    }
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

    def styles
      #TODO
      ''
    end

    def owner?
      #TODO
      true
    end

    def path_edit

      "/post/#{post.id}/edit"
    end
  end
end
