# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_03_185712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "ingredients_recipes", id: false, force: :cascade do |t|
    t.bigint "ingredient_id"
    t.bigint "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id", "recipe_id"], name: "index_ingredients_recipes_on_ingredient_id_and_recipe_id", unique: true
    t.index ["ingredient_id"], name: "index_ingredients_recipes_on_ingredient_id"
    t.index ["recipe_id"], name: "index_ingredients_recipes_on_recipe_id"
  end

  create_table "recipe_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_recipe_categories_on_name", unique: true
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title", null: false
    t.integer "prep_time"
    t.integer "cook_time"
    t.float "ratings"
    t.string "image"
    t.string "ingredients_list"
    t.bigint "recipe_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_category_id"], name: "index_recipes_on_recipe_category_id"
    t.index ["title"], name: "index_recipes_on_title", unique: true
  end

  add_foreign_key "recipes", "recipe_categories"
end
