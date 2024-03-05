# app/controllers/ingredients_controller.rb

class IngredientsController < ApplicationController
  # GET /ingredients/search?name=cucumber
  def search
    ingredient_name = params[:name]

    if ingredient_name.present?
      ingredients = Ingredient.search_by_name(ingredient_name)
      render json: ingredients
    else
      render json: { error: 'Name parameter is missing' }, status: :bad_request
    end
  end
end

