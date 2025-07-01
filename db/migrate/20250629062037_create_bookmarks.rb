class CreateBookmarks < ActiveRecord::Migration[7.2]
  # 中間テーブルの追加（ポリモーフィック関連）
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bookmarkable, polymorphic: true, null: false
      t.timestamps
    end
    add_index :bookmarks, [ :user_id, :bookmarkable_type, :bookmarkable_id ], unique: true, name: 'index_bookmarks_on_user_and_bookmarkable'
  end
end
