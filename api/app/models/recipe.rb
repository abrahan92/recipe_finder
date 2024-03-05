# == Schema Information
#
# Table name: recipes
#
#  id                 :bigint           not null, primary key
#  title              :string           not null
#  prep_time          :integer
#  cook_time          :integer
#  ratings            :float
#  image              :string
#  ingredients_list   :string
#  recipe_category_id :bigint
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Recipe < ApplicationRecord
  # Associations
  belongs_to :category, class_name: 'RecipeCategory', foreign_key: :recipe_category_id
  has_many :ingredients_recipes
  has_many :ingredients, through: :ingredients_recipes

  # Scopes
  scope :search_by_ingredients, ->(ingredients, exact_match: false) {
    if exact_match
      find_by_exact_ingredient_names(ingredients)
    else
      find_by_partial_ingredient_names(ingredients)
    end
  }

  # Class methods
  def self.build_recipe_attributes(data)
    {
      title: data['title'],
      cook_time: data['cook_time'],
      prep_time: data['prep_time'],
      ratings: data['ratings'],
      recipe_category_id: RecipeCategory.find_or_create_by(name: data['category'])&.id,
      image: data['image'],
      ingredients_list: data['ingredients'].join('; ')
    }
  end

  private

  def self.find_by_exact_ingredient_names(ingredient_names)
    normalized_ingredient_names = ingredient_names.map { |name| name.downcase.strip }

    ingredient_ids = Ingredient.where('lower(name) IN (?)', normalized_ingredient_names.map(&:downcase)).pluck(:id)

    Recipe.joins(:ingredients)
                .where(ingredients: { id: ingredient_ids })
                .group('recipes.id')
                .having('COUNT(DISTINCT ingredients.id) >= ?', ingredient_ids.size)
                .order(ratings: :desc)
  end

  def self.find_by_partial_ingredient_names(ingredient_names)
    Recipe.joins(:ingredients)
          .where('ingredients.name ILIKE ANY (array[?])', ingredient_names.map { |name| "%#{name}%" })
          .distinct
          .order(ratings: :desc)
  end
end
