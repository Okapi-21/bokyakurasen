class AddAnonymousIdToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :anonymous_id, :string
    add_index :answers, :anonymous_id
  end
end
