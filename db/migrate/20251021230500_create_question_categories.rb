class CreateQuestionCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :question_categories do |t|
      t.references :question, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.timestamps
    end
    add_index :question_categories, [:question_id, :category_id], unique: true
  end
end
