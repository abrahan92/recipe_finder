class RecipeSerializer < ActiveModel::Serializer
  attributes :id, :title, :prep_time, :cook_time, :ratings, :image, 
             :recipe_category_id, :created_at, :updated_at, :ingredients_list

  def ingredients_list
    object.ingredients_list.split('; ')
  end
end