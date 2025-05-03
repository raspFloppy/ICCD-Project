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

ActiveRecord::Schema[8.0].define(version: 2025_05_02_170859) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.pgjwt"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "classroom_students", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "classroom_id"
  end

  create_table "classrooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.uuid "professor_id"
    t.datetime "created_at", precision: nil, default: -> { "now()" }
    t.datetime "updated_at", precision: nil, default: -> { "now()" }
  end

  create_table "levels", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "code_snippet"
    t.integer "points"
  end

  create_table "student_progresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "student_id"
    t.uuid "level_id"
    t.boolean "completed", default: false
    t.integer "score"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.text "email", null: false
    t.text "encrypted_password", null: false
    t.integer "role", default: 0
    t.datetime "created_at", precision: nil, default: -> { "now()" }
    t.datetime "updated_at", precision: nil, default: -> { "now()" }

    t.unique_constraint ["email"], name: "users_email_key"
  end

  add_foreign_key "classroom_students", "classrooms", name: "classroom_students_classroom_id_fkey"
  add_foreign_key "classroom_students", "users", column: "student_id", name: "classroom_students_student_id_fkey"
  add_foreign_key "classrooms", "users", column: "professor_id", name: "classrooms_professor_id_fkey"
  add_foreign_key "student_progresses", "levels", name: "student_progresses_level_id_fkey"
  add_foreign_key "student_progresses", "users", column: "student_id", name: "student_progresses_student_id_fkey"
end
