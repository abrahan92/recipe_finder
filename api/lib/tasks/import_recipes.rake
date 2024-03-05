# lib/tasks/import_recipes.rake

namespace :db do
  desc "This task import parsed recipes from JSON file"
  task import_recipes: :environment do
    minified = ENV['MINIFIED'] == 'true'

    time = Benchmark.measure do
      RecipeImporter.call(minified: minified)
    end

    puts "Time elapsed (in seconds): #{time.real}"
  end
end