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

ActiveRecord::Schema.define(version: 20171227174455) do

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invitation_id"
    t.index ["invitation_id"], name: "index_answers_on_invitation_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title"
    t.integer "questionnaire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_campaigns_on_questionnaire_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log", limit: 1073741823
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "dialogs", force: :cascade do |t|
    t.integer "patient_id"
    t.string "user_message"
    t.string "patient_reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_dialogs_on_patient_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "patient_id"
    t.integer "campaign_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_invitations_on_campaign_id"
    t.index ["patient_id"], name: "index_invitations_on_patient_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "text"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "phoneno"
    t.boolean "telegram_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "category"
    t.string "text"
    t.integer "questionnaire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_questions_on_questionnaire_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "welcomes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
