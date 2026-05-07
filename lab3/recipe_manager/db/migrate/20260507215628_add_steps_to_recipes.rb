class AddStepsToRecipes < ActiveRecord::Migration[8.1]
  def change
    add_column :recipes, :steps, :text
  end
end
