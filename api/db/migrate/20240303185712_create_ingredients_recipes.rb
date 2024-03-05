class CreateIngredientsRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients_recipes, id: false do |t|
      t.belongs_to :ingredient
      t.belongs_to :recipe

      t.timestamps
    end

    add_index :ingredients_recipes, %i[ingredient_id recipe_id], unique: true
  end
end
