# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_08_17_051148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "owners", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.integer "espn_id"
    t.boolean "league_manager"
    t.boolean "league_creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_responses", force: :cascade do |t|
    t.text "response_body"
    t.text "response_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "league_year", null: false
    t.date "first_week_date", null: false
    t.integer "champion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "second_place_id"
    t.integer "third_place_id"
    t.integer "last_place_id"
  end

  create_table "team_matchups", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "score"
    t.integer "season_id"
    t.integer "week_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "regular_season"
    t.integer "opponent_id"
    t.integer "opponent_score"
    t.date "matchup_date"
    t.index ["opponent_id"], name: "index_team_matchups_on_opponent_id"
    t.index ["season_id"], name: "index_team_matchups_on_season_id"
    t.index ["team_id"], name: "index_team_matchups_on_team_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "logo_url"
    t.integer "wins"
    t.integer "losses"
    t.integer "ties"
    t.float "points_for"
    t.float "points_against"
    t.integer "league_year"
    t.integer "standing"
    t.integer "acquisitions"
    t.integer "drops"
    t.integer "trades"
    t.integer "acquisition_spent"
    t.integer "acquisition_remaining"
    t.integer "current_streak"
    t.integer "owner_id"
    t.integer "external_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "web_response_id"
    t.integer "total_score"
  end

  create_table "web_responses", id: :serial, force: :cascade do |t|
    t.integer "external_league_id"
    t.string "league_year"
    t.text "response_body"
    t.text "response_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
