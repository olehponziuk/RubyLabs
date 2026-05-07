class PhotosController < ApplicationController
  before_action :set_photo, only: %i[show edit update destroy]

  def index
    @photos = Photo.all
  end

  def show; end

  def new
    @photo = Photo.new
    @photo.recipe_id = params[:recipe_id]
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_to @photo.recipe_id ? recipe_path(@photo.recipe_id) : photos_path,
                  notice: "Фото додано."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: "Фото оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recipe_id = @photo.recipe_id
    @photo.destroy
    redirect_to recipe_id ? recipe_path(recipe_id) : photos_path,
                notice: "Фото видалено."
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:caption, :url, :recipe_id)
  end
end
