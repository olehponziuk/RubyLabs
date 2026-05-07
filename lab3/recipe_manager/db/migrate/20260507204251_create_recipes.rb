class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :category
      t.integer :cooking_time
      t.integer :servings
      t.integer :difficulty
      t.boolean :published

      t.timestamps
    end
  end
end
