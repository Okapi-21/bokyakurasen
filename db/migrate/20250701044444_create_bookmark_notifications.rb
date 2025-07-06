class CreateBookmarkNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :bookmark_notifications do |t|
      t.references :bookmark, null: false, foreign_key: true
      t.integer :notification_number, null: false, default: 0
      t.datetime :sent_at

      t.timestamps
    end
  end
end
