class FoldersController < ApplicationController

  def index
    render json: {
      list: Folder.owned_by(current_user).map { |f| { id: f.id, name: f.name } }
    }
  end

  def create
    folder = Folder.create!(folder_params.merge(owner: current_user))

    render json: {
      result: 0,
      object: {
        id: folder.id,
        name: folder.name,
      }
    }
  end

  def update
    Folder.update(params[:id], folder_params)
  end

  def destroy
    Folder.destroy(params[:id])
  end

  private

  def folder_params
    params.require(:folder).permit(:id, :name)
  end
end