require 'json'
require 'yaml'
require_relative 'recipe'

class RecipeManager
  def initialize
    @collection = {}
  end

  def add_recipe(title, ingredients, steps, category, cooking_time, servings, difficulty)
    id = (@collection.keys.max || 0) + 1
    @collection[id] = Recipe.new(title, ingredients, steps, category, cooking_time, servings, difficulty)
    id
  end

  def edit_recipe(id, new_data)
    raise "Запис #{id} не знайдено" unless @collection.key?(id)
    new_data.each { |key, value| @collection[id].send("#{key}=", value) }
  end

  def delete_recipe(id)
    raise "Запис #{id} не знайдено" unless @collection.key?(id)
    @collection.delete(id)
  end

  def list_recipes
    @collection
  end

  def find_by_title(query)
    @collection.select { |_, r| r.title.downcase.include?(query.downcase) }
  end

  def filter_by_category(category)
    @collection.select { |_, r| r.category.downcase == category.downcase }
  end

  def filter_by_difficulty(difficulty)
    @collection.select { |_, r| r.difficulty.downcase == difficulty.downcase }
  end

  def save_to_yaml(filename)
    File.write(filename, @collection.to_yaml)
  end

  def load_from_yaml(filename)
    @collection = YAML.unsafe_load(File.read(filename)) || {}
  rescue Errno::ENOENT
    @collection = {}
  end

  def save_to_json(filename)
    data = @collection.transform_keys(&:to_s).transform_values(&:to_h)
    File.write(filename, JSON.pretty_generate(data))
  end

  def load_from_json(filename)
    data = JSON.parse(File.read(filename))
    @collection = data.transform_keys(&:to_i).transform_values { |h| Recipe.from_h(h) }
  rescue Errno::ENOENT
    @collection = {}
  end

  def size
    @collection.size
  end

  def empty?
    @collection.empty?
  end
end
