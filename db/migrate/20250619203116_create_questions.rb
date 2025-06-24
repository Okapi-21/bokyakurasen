class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :questions }
      t.string :title, null: false
      t.text :description, null: false
      t.integer :current_count, default: 0
      t.integer :false_count, default: 0
      t.boolean :listed, default: false

      t.timestamps
    end
  end
end
