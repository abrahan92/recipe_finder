require 'rails_helper'

RSpec.describe RecipeSerializer, type: :serializer do
  let(:ingredients_list) { "1 cup all-purpose flour; 1 cup yellow cornmeal" }
  let(:recipe) { create(:recipe, ingredients_list: ingredients_list) }
  let(:serializer) { RecipeSerializer.new(recipe) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:json) { JSON.parse(serialization.to_json) }
  let(:expected_attributes) do
    %w[
      id title prep_time cook_time ratings
      image recipe_category_id created_at updated_at ingredients_list
    ]
  end
  let(:expected_ingredients_list) { ["1 cup all-purpose flour", "1 cup yellow cornmeal"] }

  it 'includes the expected attributes' do
    expect(json.keys).to contain_exactly(*expected_attributes)
  end

  it 'correctly serializes the ingredients list' do
    expect(json['ingredients_list']).to eq(expected_ingredients_list)
  end
end
