class Answer < ApplicationRecord
    belongs_to :user
    belongs_to :question
    belongs_to :choice

    validates :user_id, :question_id, :choice_id, presence: true

    before_create :set_is_correct

    private

    def set_is_correct
        self.is_correct = choice.is_correct
    end
end
