require 'date'

class Recipe
  attr_accessor :title, :ingredients, :steps, :category, :cooking_time, :servings, :difficulty, :created_at, :published

  def initialize(title, ingredients, steps, category, cooking_time, servings, difficulty)
    @title        = title
    @ingredients  = ingredients
    @steps        = steps
    @category     = category
    @cooking_time = cooking_time
    @servings     = servings
    @difficulty   = difficulty
    @created_at   = Date.today.to_s
    @published    = false
  end

  def to_h
    {
      'title'        => @title,
      'ingredients'  => @ingredients,
      'steps'        => @steps,
      'category'     => @category,
      'cooking_time' => @cooking_time,
      'servings'     => @servings,
      'difficulty'   => @difficulty,
      'created_at'   => @created_at,
      'published'    => @published
    }
  end

  def self.from_h(hash)
    h = hash.transform_keys(&:to_s)
    recipe = new(
      h['title'], h['ingredients'], h['steps'],
      h['category'], h['cooking_time'], h['servings'], h['difficulty']
    )
    recipe.created_at = h['created_at']
    recipe.published  = h['published']
    recipe
  end
end
