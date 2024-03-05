# spec/support/rake_context.rb

RSpec.shared_context 'rake' do
  before(:all) do
    Rake.application = Rake::Application.new
    Rake.application.rake_require('import_recipes', [Rails.root.join('lib', 'tasks').to_s])
    Rake::Task.define_task(:environment)
  end

  after(:all) do
    Rake.application = nil
  end
end
