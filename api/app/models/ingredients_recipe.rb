# == Schema Information
#
# Table name: ingredients_recipes
#
#  ingredient_id :bigint
#  recipe_id     :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class IngredientsRecipe < ApplicationRecord
  # Associations
  belongs_to :ingredient
  belongs_to :recipe
end
