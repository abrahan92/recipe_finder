require 'rails_helper'

RSpec.describe IngredientParser do
  let(:cleanup_rules_filepath) { Rails.root.join('spec', 'fixtures', 'cleanup_rules.json') }
  let(:cleanup_rules) do
    {
      "measures": ["cup", "tablespoon"],
      "words_to_remove": ["fresh", "diced"]
    }
  end

  before do
    allow(Settings.files).to receive(:cleanup_file_path).and_return(cleanup_rules_filepath)
    allow(File).to receive(:read).with(cleanup_rules_filepath).and_return(cleanup_rules.to_json)
  end

  describe '.call' do
    it 'removes measures and unwanted words, normalizes and singularizes ingredient names' do
      ingredient_string = "2 cups diced fresh tomatoes"
      expected_output = "tomato"

      expect(IngredientParser.call(ingredient_string)).to eq(expected_output)
    end

    it 'handles special characters and accents, converting them to ascii' do
      ingredient_string = "½ cup diced jalapeños"
      expected_output = "jalapeno"

      expect(IngredientParser.call(ingredient_string)).to eq(expected_output)
    end
  end
end