class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false, index: { unique: true }
      t.integer :prep_time
      t.integer :cook_time
      t.float :ratings
      t.string :image
      t.string :ingredients_list
      t.references :recipe_category, null: true, foreign_key: true

      t.timestamps
    end
  end
end
