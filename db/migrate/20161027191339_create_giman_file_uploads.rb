class CreateGimanFileUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :giman_file_uploads do |t|
      t.string   "filename",         null: false
      t.string   "content_type",     null: false
      t.datetime "last_modified_at"
      t.integer  "size",             null: false
      t.string   "url",              null: false
      t.string   "s3_path",          null: false
      t.integer  "attachable_id"
      t.string   "attachable_type"

      t.timestamps
    end
  end
end
