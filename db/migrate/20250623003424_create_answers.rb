class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :choice, null: false, foreign_key: true

      t.boolean :is_correct, null: false, default: false
      t.datetime :answered_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
