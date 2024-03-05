require 'rails_helper'

RSpec.describe 'db:import_recipes rake task' do
  include_context 'rake'

  let(:task) { Rake.application['db:import_recipes'] }

  it 'calls RecipeImporter.call' do
    expect(RecipeImporter).to receive(:call).with(minified: false)
    task.invoke
  end
end
