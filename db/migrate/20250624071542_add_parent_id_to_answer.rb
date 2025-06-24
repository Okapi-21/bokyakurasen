class AddParentIdToAnswer < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :parent_question_id, :integer
  end
end
