# == Schema Information
#
# Table name: recipe_categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RecipeCategory < ApplicationRecord
  # Associations
  has_many :recipes

  # Validations
  validates :name, presence: true
end
