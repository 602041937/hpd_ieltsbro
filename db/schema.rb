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

ActiveRecord::Schema.define(version: 20171201145443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "app_collections", force: :cascade do |t|
    t.string "collection_type"
    t.integer "item_id"
    t.integer "app_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_collections_on_app_user_id"
  end

  create_table "app_destination_countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_exam_cities", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_exam_dates", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_exam_locations", force: :cascade do |t|
    t.string "location"
    t.bigint "app_exam_city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_exam_city_id"], name: "index_app_exam_locations_on_app_exam_city_id"
  end

  create_table "app_fan_users", force: :cascade do |t|
    t.integer "app_user_id"
    t.integer "fan_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_fan_users_on_app_user_id"
  end

  create_table "app_oral_memories", force: :cascade do |t|
    t.integer "app_user_id"
    t.integer "app_part23_topic_id"
    t.integer "app_exam_location_id"
    t.integer "app_exam_date_id"
    t.string "room_number", default: ""
    t.boolean "is_old", default: false
    t.string "part1", default: ""
    t.string "part2", default: ""
    t.string "part3", default: ""
    t.string "part_all", default: ""
    t.string "impression", default: ""
    t.integer "comment_count", default: 0
    t.boolean "is_show", default: true
    t.integer "collections", default: 0
    t.boolean "part1_is_new_state", default: false
    t.boolean "part23_is_new_state", default: false
    t.boolean "is_meaningless", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_exam_date_id"], name: "index_app_oral_memories_on_app_exam_date_id"
    t.index ["app_exam_location_id"], name: "index_app_oral_memories_on_app_exam_location_id"
    t.index ["app_part23_topic_id"], name: "index_app_oral_memories_on_app_part23_topic_id"
    t.index ["app_user_id"], name: "index_app_oral_memories_on_app_user_id"
  end

  create_table "app_oral_memories_app_part1_topics", force: :cascade do |t|
    t.integer "app_oral_memory_id"
    t.integer "app_part1_topic_id"
    t.index ["app_oral_memory_id"], name: "index_app_oral_memories_app_part1_topics_on_app_oral_memory_id"
    t.index ["app_part1_topic_id"], name: "index_app_oral_memories_app_part1_topics_on_app_part1_topic_id"
  end

  create_table "app_oral_memory_comments", force: :cascade do |t|
    t.integer "app_oral_memory_id"
    t.integer "app_user_id"
    t.integer "to_user_id"
    t.string "content"
    t.integer "to_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_memory_id"], name: "index_app_oral_memory_comments_on_app_oral_memory_id"
    t.index ["app_user_id"], name: "index_app_oral_memory_comments_on_app_user_id"
  end

  create_table "app_oral_practice_comment_comments", force: :cascade do |t|
    t.integer "app_oral_practice_comment_id"
    t.integer "app_user_id"
    t.integer "to_comment_id"
    t.integer "to_user_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_practice_comment_id"], name: "app_oral_practice_comment_comments_index"
    t.index ["app_user_id"], name: "index_app_oral_practice_comment_comments_on_app_user_id"
  end

  create_table "app_oral_practice_comments", force: :cascade do |t|
    t.integer "app_user_id"
    t.integer "seconds"
    t.string "audio_record"
    t.integer "app_oral_practice_question_id"
    t.integer "play_times", default: 0
    t.boolean "is_show", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_practice_question_id"], name: "app_oral_practice_comments_index"
    t.index ["app_user_id"], name: "index_app_oral_practice_comments_on_app_user_id"
  end

  create_table "app_oral_practice_part1_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_oral_practice_part23_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_oral_practice_questions", force: :cascade do |t|
    t.integer "app_part1_topic_id"
    t.integer "app_part23_topic_id"
    t.string "topic"
    t.string "description"
    t.boolean "is_show", default: true
    t.integer "comment_count", default: 0
    t.string "vu"
    t.string "uu"
    t.integer "question_order"
    t.integer "part_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_part1_topic_id"], name: "index_app_oral_practice_questions_on_app_part1_topic_id"
    t.index ["app_part23_topic_id"], name: "index_app_oral_practice_questions_on_app_part23_topic_id"
  end

  create_table "app_oral_practice_sample_answers", force: :cascade do |t|
    t.string "content", default: ""
    t.integer "app_user_id", null: false
    t.boolean "is_show", default: true
    t.boolean "is_default", default: true
    t.integer "app_oral_practice_question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_practice_question_id"], name: "app_oral_practice_sample_answers_index"
    t.index ["app_user_id"], name: "index_app_oral_practice_sample_answers_on_app_user_id"
  end

  create_table "app_oral_practice_stars", force: :cascade do |t|
    t.integer "fluent", default: 0
    t.integer "vocab", default: 0
    t.integer "grammar", default: 0
    t.integer "pronuce", default: 0
    t.integer "app_user_id"
    t.integer "app_oral_practice_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "to_user_id"
    t.index ["app_oral_practice_comment_id"], name: "index_app_oral_practice_stars_on_app_oral_practice_comment_id"
    t.index ["app_user_id"], name: "index_app_oral_practice_stars_on_app_user_id"
  end

  create_table "app_part1_topics", force: :cascade do |t|
    t.string "topic"
    t.string "content"
    t.boolean "is_show"
    t.integer "app_oral_practice_part1_category_id"
    t.integer "total_count"
    t.integer "oral_practice_collections"
    t.string "oral_practice_description"
    t.integer "total_comment_count"
    t.string "tags"
    t.integer "topic_order"
    t.boolean "is_show_tab2"
    t.boolean "is_sleep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_practice_part1_category_id"], name: "index_app_part1_topics_on_app_oral_practice_part1_category_id"
  end

  create_table "app_part23_topics", force: :cascade do |t|
    t.string "topic"
    t.string "content"
    t.boolean "is_show"
    t.integer "app_oral_practice_part23_category_id"
    t.integer "total_count"
    t.integer "oral_practice_collections"
    t.string "oral_practice_description"
    t.integer "total_comment_count"
    t.string "tags"
    t.integer "topic_order"
    t.boolean "is_show_tab2"
    t.boolean "is_sleep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_oral_practice_part23_category_id"], name: "index_app_part23_topics_on_app_oral_practice_part23_category_id"
  end

  create_table "app_user_reports", force: :cascade do |t|
    t.string "report_type"
    t.integer "item_id"
    t.integer "app_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_user_reports_on_app_user_id"
  end

  create_table "app_users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "password", default: "", null: false
    t.string "mobile", default: "", null: false
    t.string "zone", default: "", null: false
    t.string "avatar", default: ""
    t.string "token", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "app_exam_date_id"
    t.bigint "app_exam_location_id"
    t.string "sex"
    t.string "device"
    t.string "current_location"
    t.integer "name_update_count"
    t.string "push_token"
    t.string "device_uid"
    t.string "device_name"
    t.string "app_version"
    t.string "system_version"
    t.integer "app_destination_id"
    t.index ["app_destination_id"], name: "index_app_users_on_app_destination_id"
    t.index ["app_exam_date_id"], name: "index_app_users_on_app_exam_date_id"
    t.index ["app_exam_location_id"], name: "index_app_users_on_app_exam_location_id"
  end

  create_table "app_video_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_video_comments", force: :cascade do |t|
    t.integer "app_user_id"
    t.integer "to_user_id"
    t.string "content", default: ""
    t.integer "app_video_id"
    t.integer "to_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_video_comments_on_app_user_id"
    t.index ["app_video_id"], name: "index_app_video_comments_on_app_video_id"
  end

  create_table "app_video_likes", force: :cascade do |t|
    t.integer "app_user_id"
    t.integer "app_video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_video_likes_on_app_user_id"
    t.index ["app_video_id"], name: "index_app_video_likes_on_app_video_id"
  end

  create_table "app_videos", force: :cascade do |t|
    t.string "name", default: ""
    t.integer "view_count"
    t.string "vu", default: ""
    t.string "uu", default: ""
    t.string "snapshot_url", default: ""
    t.integer "vid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "app_videos_app_video_categories", force: :cascade do |t|
    t.integer "app_video_id"
    t.integer "app_video_category_id"
    t.index ["app_video_category_id"], name: "index_app_videos_app_video_categories_on_app_video_category_id"
    t.index ["app_video_id"], name: "index_app_videos_app_video_categories_on_app_video_id"
  end

  create_table "app_written_images", force: :cascade do |t|
    t.integer "app_written_memory_id"
    t.string "memory_type"
    t.string "image"
    t.integer "image_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_written_memory_id"], name: "index_app_written_images_on_app_written_memory_id"
  end

  create_table "app_written_memories", force: :cascade do |t|
    t.integer "app_user_id"
    t.string "listening"
    t.string "reading"
    t.string "writing"
    t.string "extras"
    t.integer "comment_counts", default: 0
    t.string "location", default: "中国大陆"
    t.string "exam_date", default: ""
    t.integer "collections", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_written_memories_on_app_user_id"
  end

  create_table "app_written_memory_comments", force: :cascade do |t|
    t.integer "app_written_memory_id"
    t.integer "app_user_id"
    t.integer "to_comment_id"
    t.integer "to_user_id"
    t.string "content"
    t.integer "the_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_user_id"], name: "index_app_written_memory_comments_on_app_user_id"
    t.index ["app_written_memory_id"], name: "index_app_written_memory_comments_on_app_written_memory_id"
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

end
