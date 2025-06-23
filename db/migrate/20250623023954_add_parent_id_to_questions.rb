class AddParentIdToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :parent_id, :integer
  end
end
