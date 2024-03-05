require 'rails_helper'

RSpec.describe RecipeImporter do
  describe '.call' do
    let(:batch_size) { 2 }
    let(:recipe_dataset_file_path) { 'spec/fixtures/recipes.json' }
    let(:cleanup_file_path) { 'spec/fixtures/ingredient_cleanup_rules.json' }
    let(:recipes_json) do
      [
        {
          "title": "Recipe 1",
          "ingredients": [
            "1 cup all-purpose flour",
            "⅔ cup white sugar"
          ],
          "cook_time": 15,
          "prep_time": 5,
          "ratings": 4.5,
          "category": "Category 1",
          "image": "image1.jpg"
        },
        {
          "title": "Recipe 2",
          "ingredients": [
            "½ cup margarine",
            "1 cup packed brown sugar",
          ],
          "cook_time": 20,
          "prep_time": 10,
          "ratings": 4.0,
          "category": "Category 2",
          "image": "image2.jpg"
        }
      ].to_json
    end
    let(:cleanup_rules) do
      {
        "measures": ["cup", "cups", "teaspoon", "teaspoons", "tablespoon", "tablespoons"],
        "words_to_remove": ["packed"]
      }.to_json
    end

    before do
      allow(Settings).to receive_message_chain(:processing, :batch_size).and_return(batch_size)
      allow(Settings).to receive_message_chain(:files, :recipe_dataset_file_path).and_return(recipe_dataset_file_path)
      allow(Settings).to receive_message_chain(:files, :cleanup_file_path).and_return(cleanup_file_path)
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with(cleanup_file_path).and_return(cleanup_rules)
      allow(File).to receive(:read).with(recipe_dataset_file_path).and_return(recipes_json)
    end

    it 'correctly imports recipes and their ingredients in batches' do
      expect { RecipeImporter.call }.to change { Recipe.count }.by(2)
                                      .and change { Ingredient.count }.by(4)
                                      .and change { IngredientsRecipe.count }.by(4)
    end

    context 'when file format is not supported' do
      before do
        allow(Settings.files).to receive(:recipe_dataset_file_path).and_return(Rails.root.join('spec', 'fixtures', 'recipes.xml'))
      end

      it 'handles unsupported file formats gracefully' do
        expect { RecipeImporter.call }.to raise_error(ArgumentError, "Unsupported file format: .xml.")
      end
    end
  end
end