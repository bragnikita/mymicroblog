class ImagesController < ApplicationController

  def index
    render 'index', layout: 'layouts/config'
  end

  def list
    if params.has_key?(:folder)
      images = Image.where(folder_id: params[:folder])
    else
      images = Image.all
    end
    render json: {
      result: 0,
      list: images.map do |image|
        {
          id: image.id,
          url: image.link.url,
          title: image.title
        }
      end
    }
  end

  def add
    @image = Image.create!(image_params)

    folder = {}
    if @image.folder.present?
      folder[:folder_id] = @image.folder_id
      folder[:folder_name] = @image.folder.name
      folder[:folder_title] = @image.folder.title
    end

    render json: {
      result: 0,
      object: {
        id: @image.id,
        url: @image.link.url,
        title: @image.title
      }.merge(folder)
    }
  end

  def destroy

  end

  private

  def image_params
    params.require(:image).permit(:link, :folder_id, :title)
  end
end