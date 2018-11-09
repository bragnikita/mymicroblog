class ImagesController < ApplicationController

  def index
    if request.xhr?
      render json: {}
    end
    render 'index', layout: 'layouts/config'
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