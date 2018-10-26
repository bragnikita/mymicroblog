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
    p = post_parameters
    post = Post.find(p[:id])
    attrs_to_update = p.slice(:title, :excerpt, :slug)
    post.update!(attrs_to_update)
    if p.dig(:contents, :main)
      post.source_content_obj.update!({content: p[:contents][:main]})
      post.filtered_content_obj.update!({content: p[:contents][:main]})
    end

    slug = post.slug
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

  private

  def post_parameters
    params.permit(:id, :title, :slug, :excerpt, contents: {})
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
