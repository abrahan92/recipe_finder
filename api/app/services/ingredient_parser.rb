# app/services/ingredient_parser.rb

require 'json'
require 'unidecoder'

class IngredientParser
  def self.call(ingredient_string)
    new(ingredient_string).call
  end

  def initialize(ingredient_string)
    @ingredient_string = ingredient_string
    @cleanup_rules = JSON.parse(File.read(cleanup_rules_filepath)).with_indifferent_access
  end

  def call
    extract_ingredient_name(@ingredient_string)
  end

  private

  def cleanup_rules_filepath
    Settings.files.cleanup_file_path
  end

  # Returns the cleanup rules for measures from the cleanup rules file.
  #
  # @return [Array<String>] The list of measures to remove from the ingredient name.
  def measures
    @cleanup_rules[:measures]
  end

  # Returns the cleanup rules for words to remove from the cleanup rules file.
  #
  # @return [Array<String>] The list of words to remove from the ingredient name.
  def words_to_remove
    @cleanup_rules[:words_to_remove]
  end

  # Extracts and cleans an ingredient name from a given input string.
  # This method performs several normalization and cleaning steps to transform
  # the raw ingredient input into a more standardized form.
  #
  # @param input [String] The raw input string containing the ingredient name.
  # @return [String] The cleaned and normalized ingredient name.
  def extract_ingredient_name(input)
    special_cases = { 'ñ' => 'n' }
    input_normalized = input.chars.map { |char| special_cases[char] || char }.join

    normalized_input = Unidecoder.decode(input_normalized.downcase).gsub(/[^a-z\s]/i, '')

    cleaned_words = normalized_input.split.map do |word|
      singular_word = word.singularize
      singular_word unless measures.include?(singular_word) || words_to_remove.include?(singular_word)
    end.compact.uniq
  
    cleaned_words.join(' ').strip
  end
end