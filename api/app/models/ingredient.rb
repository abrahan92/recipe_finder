# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Ingredient < ApplicationRecord
  # Associations
  has_many :ingredients_recipes
  has_many :recipes, through: :ingredients_recipes

  # Validations
  validates :name, presence: true, uniqueness: true

  # Scopes
  scope :search_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
