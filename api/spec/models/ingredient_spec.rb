require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:ingredients_recipes) }
    it { is_expected.to have_many(:recipes).through(:ingredients_recipes) }
  end

  it { is_expected.to validate_presence_of(:name) }

  describe '.validations' do
    subject { Ingredient.new(name: 'Sugar') }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
