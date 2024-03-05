# app/services/recipe_importer.rb

class RecipeImporter
  BATCH_SIZE = Settings.processing.batch_size

  def self.call(minified: false)
    new(minified).call
  end

  def initialize(minified)
    @minified = minified
  end

  def call
    load_file_data
    import_data
  end

  private

  def recipe_file_path
    @minified ?
      Settings.files.recipe_dataset_file_path_minified :
      Settings.files.recipe_dataset_file_path
  end

  def extension
    File.extname(recipe_file_path).delete('.')
  end

  def load_file_data
    case extension
    when 'json'
      @recipes = JSON.parse(File.read(recipe_file_path))
    else
      raise ArgumentError, "Unsupported file format: .#{extension}."
    end
  end

  def import_data
    @recipes.each_slice(BATCH_SIZE).map do |recipe_batch|
      ActiveRecord::Base.transaction do
        process_batch(recipe_batch)
      end
    end
  end

  # Processes a batch of recipes, including their ingredients and the associations between recipes and ingredients.
  # This method perform the batch processing by preparing and inserting data in three main steps.
  #
  # @param recipe_batch [Array<Hash>] An array of hashes, where each hash represents a recipe and its details.
  def process_batch(recipe_batch)
    main_batch = prepare_recipe_batch(recipe_batch)
    bulk_insert_recipes(main_batch)

    ingredients = prepare_ingredient_batch(recipe_batch)
    bulk_insert_ingredients(ingredients)

    
    ingredients_associations = prepare_ingredients_associations(recipe_batch)
    bulk_insert_associations(ingredients_associations)
  end
  
  # Step 1. Prepare the array of recipes from the recipe batch and insert them into the database.
  # This step involves transforming the recipe data into a suitable format for insertion
  # and then performing a bulk insert to efficiently add multiple recipes at once.
  def prepare_recipe_batch(recipe_batch)
    recipe_batch.map do |recipe_data|
      Recipe.build_recipe_attributes(recipe_data)
    end
  end

  def bulk_insert_recipes(main_batch)
    Recipe.upsert_all(main_batch, unique_by: [:index_recipes_on_title])
  end

  # Step 2. Prepare the batch of ingredients extracted from the recipe batch.
  # Similar to recipes, this prepares the ingredient data for bulk insertion,
  # ensuring that each ingredient is properly parsed with IngredientParser before insertion.
  def prepare_ingredient_batch(recipe_batch)
    ingredients = []
    recipe_batch.each do |recipe_data|
      recipe_data['ingredients'].each do |ingredient_name|
        parsed_ingredient_name = IngredientParser.call(ingredient_name)
        if valid_ingredient?(parsed_ingredient_name)
          ingredients << { name: parsed_ingredient_name }
        end
      end
    end

    ingredients
  end
  
  def valid_ingredient?(ingredient_name)
    ingredient_name.present? && ingredient_name.split.size <= 2
  end

  def bulk_insert_ingredients(ingredients)
    Ingredient.upsert_all(ingredients, unique_by: [:index_ingredients_on_name])
  end

  # Step 3. Prepare the associations between recipes and ingredients based on the current batch.
  # This involves creating a list of connections that define which ingredients belong to which recipes.
  # Once prepared, these associations are bulk inserted to efficiently establish the relationships in the database.
  def prepare_ingredients_associations(recipe_batch)
    ingredients_associations = []
    recipe_batch.each_with_index do |recipe_data, index|
      recipe_title = recipe_data.with_indifferent_access['title']
      recipe_id = Recipe.find_by(title: recipe_title)&.id
      next unless recipe_id

      recipe_data['ingredients'].each do |ingredient_data|
        parsed_ingredient_name = IngredientParser.call(ingredient_data)
        next if !valid_ingredient?(parsed_ingredient_name)

        ingredient_id = Ingredient.find_by(name: parsed_ingredient_name)&.id
        next unless ingredient_id

        ingredients_associations << { recipe_id: recipe_id, ingredient_id: ingredient_id }
      end
    end

    ingredients_associations
  end

  def bulk_insert_associations(ingredients_associations)
    IngredientsRecipe.upsert_all(ingredients_associations.uniq, unique_by: [:index_ingredients_recipes_on_ingredient_id_and_recipe_id])
  end
end
