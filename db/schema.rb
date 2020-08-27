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

ActiveRecord::Schema.define(version: 2020_06_10_194457) do

  create_table "appointments", force: :cascade do |t|
    t.datetime "begin_datetime"
    t.datetime "end_datetime"
    t.string "note"
    t.integer "student_id"
    t.integer "tutor_id"
    t.boolean "taken", default: false
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "password"
  end

  create_table "tutors", force: :cascade do |t|
    t.string "name"
    t.string "subject"
    t.integer "years_of_experience"
  end

end
