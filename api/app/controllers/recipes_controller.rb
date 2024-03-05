# app/controllers/recipes_controller.rb

class RecipesController < ApplicationController
  DEFAULT_PAGE = 1
  PER_PAGE = 12

  # GET /recipes/search?ingredients=allpurpose+flour,sugar&page=1&exact_match=true
  def search
    ingredients = search_params[:ingredients]&.split(',')
    exact_match = search_params[:exact_match] == 'true'
    page = search_params[:page] || DEFAULT_PAGE

    if ingredients.present?
      recipes = Recipe.search_by_ingredients(ingredients, exact_match: exact_match).page(page).per(PER_PAGE)

      render json: recipes, each_serializer: RecipeSerializer, meta: {
        total_pages: recipes.total_pages,
        total_count: recipes.total_count,
        page: recipes.current_page
      }, adapter: :json

    else
      render json: { error: 'Ingredients parameter is missing' }, status: :bad_request
    end
  end

  private

  def search_params
    params.permit(:ingredients, :exact_match, :page)
  end
end
