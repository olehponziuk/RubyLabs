class RecipesController < ApplicationController
  before_action :set_recipe,    only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit create update]

  def index
    @recipes = Recipe.all
  end

  def published
    @recipes = Recipe.where(published: true)
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "Рецепт створено."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "Рецепт оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: "Рецепт видалено."
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_categories
    @categories = Category.pluck(:name)
  end

  def recipe_params
    params.require(:recipe).permit(:title, :category, :cooking_time, :servings, :difficulty, :published)
  end
end
