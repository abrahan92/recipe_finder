FactoryBot.define do
  factory :recipe do
    title { "Carrot Cake by Abrahan" }
    prep_time { 1 }
    cook_time { 1 }
    ratings { 1.5 }
    image { "localhost:3000/carrot_cake.jpg" }
    ingredients_list { "Carrot; Flour; Sugar" }
    category { create(:recipe_category) }
  end

  trait :brownie do
    title { "Brownie by Abrahan" }
    prep_time { 2 }
    cook_time { 2 }
    ratings { 2.5 }
    image { "localhost:3000/brownie.jpg" }
    ingredients_list { "Chocolate; Flour; Sugar" }
    category { RecipeCategory.find_or_create_by(name: 'Dessert') }

    after(:create) do |recipe|
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Chocolate'))
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Flour'))
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Sugar'))
    end
  end

  trait :carrot_cake do
    title { "Carrot Cake by Abrahan" }
    prep_time { 1 }
    cook_time { 1 }
    ratings { 1.5 }
    image { "localhost:3000/carrot_cake.jpg" }
    ingredients_list { "Carrot; Flour; Sugar" }
    category { RecipeCategory.find_or_create_by(name: 'Dessert') }

    after(:create) do |recipe|
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Carrot'))
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Flour'))
      create(:ingredients_recipe, recipe: recipe, ingredient: Ingredient.find_or_create_by(name: 'Sugar'))
    end
  end
end
