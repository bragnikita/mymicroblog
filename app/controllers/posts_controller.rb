class PostsController < ApplicationController

  def index
    @index = IndexViewModel.new(Post.total_index(params))
    render 'index', layout: 'layouts/config'
  end

  def new
    @page.title = "New post"
    render 'new', layout: 'layouts/config'
  end


  def edit
    post = Post.find(params[:id])
    page.title = "[Edit]#{post.title}"
    render 'edit'
  end

  def update
    p = post_parameters
    op = Operations::UpdatePost.new.from_params(p).call!.result
    if request.xhr?
      render json: {
        result: 0,
        redirect_to: "/p/#{op.model.slug}"
      }
    else
      redirect_to "/p/#{op.model.slug}"
    end
  end

  def create
    slug = params[:slug]
    Operations::AddPost.new(post_parameters).call
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
    contents_roles = params.fetch(:roles, '').split(',')
    post = Post.find(params[:id])
    render json: {
      object: {
        id: post.id,
        title: post.title,
        slug: post.slug,
        excerpt: post.excerpt,
        post_type: post.post_type,
        contents: post.contents_for(contents_roles).each_with_object({}) do |c, hash|
          hash[c.role] = {
            content: c.content,
            content_format: c.content_format,
          }
        end,
      }
    }
  end

  private

  def post_parameters
    params.permit(:id, :title, :slug, :excerpt, :post_type, contents: {})
  end

  class IndexViewModel
    attr_accessor :relation, :collection

    def initialize(relation)
      @relation = relation
      @collection = relation.map{|p| ViewModel.new(p)}
    end

  end

  class ViewModel
    attr_accessor :post

    def initialize(post)
      @post = post
    end

    def model
      @post
    end

    def text
      @post.main_content_filtered_text
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

    def path_view
      "/p/#{post.slug}"
    end

    def path_edit
      "/post/#{post.id}/edit"
    end
  end
end
