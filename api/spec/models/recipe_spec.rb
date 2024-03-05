require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { should belong_to(:category).class_name('RecipeCategory').with_foreign_key(:recipe_category_id) }
    it { should have_many(:ingredients_recipes) }
    it { should have_many(:ingredients).through(:ingredients_recipes) }
  end

  describe '.find_by_ingredient_names' do
    let!(:brownie) { create(:recipe, :brownie) }
    let!(:carrot_cake) { create(:recipe, :carrot_cake) }

    context 'with exact_match set to true' do
      it 'finds recipes with exactly matching ingredient names' do
        results = Recipe.search_by_ingredients(['chocolate', 'sugar'], exact_match: true)
        expect(results).to include(brownie)
        expect(results).not_to include(carrot_cake)
      end
    end

    context 'with exact_match set to false' do
      it 'finds recipes with partially matching ingredient names' do
        results = Recipe.search_by_ingredients(['chocolate', 'sugar'], exact_match: false)
        expect(results).to include(brownie).and include(carrot_cake)
      end
    end
  end

  describe '.build_recipe_attributes' do
    let(:data) do
      {
        'title' => 'Test Recipe',
        'cook_time' => 30,
        'prep_time' => 15,
        'ratings' => 4.5,
        'category' => 'Dessert',
        'image' => 'test_image.png',
        'ingredients' => ['Sugar', 'Flour']
      }
    end

    it 'builds a hash of recipe attributes from provided data' do
      category = create(:recipe_category, name: 'Dessert')
      attributes = Recipe.build_recipe_attributes(data)
      
      expect(attributes[:title]).to eq('Test Recipe')
      expect(attributes[:cook_time]).to eq(30)
      expect(attributes[:prep_time]).to eq(15)
      expect(attributes[:ratings]).to eq(4.5)
      expect(attributes[:recipe_category_id]).to eq(category.id)
      expect(attributes[:image]).to eq('test_image.png')
      expect(attributes[:ingredients_list]).to eq('Sugar; Flour')
    end
  end
end
