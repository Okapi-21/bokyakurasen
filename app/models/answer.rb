class Answer < ApplicationRecord
    belongs_to :user
    belongs_to :question
    belongs_to :choice

    validates :user_id, :question_id, :choice_id, presence: true
end
