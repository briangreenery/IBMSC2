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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925062141) do

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_points"
    t.integer  "loser_points"
    t.integer  "tournament_id"
    t.string   "replay_file"
    t.string   "map"
    t.string   "winner_race",   :limit => 1
    t.string   "loser_race",    :limit => 1
    t.integer  "start_time"
    t.integer  "length"
    t.string   "sha1",          :limit => 40
  end

  add_index "matches", ["sha1"], :name => "index_matches_on_sha1"

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "character_code"
    t.integer  "league"
  end

  create_table "standings", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "player_id"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
