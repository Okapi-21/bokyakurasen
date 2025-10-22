class Answer < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :question
    belongs_to :choice

    validates :question_id, :choice_id, presence: true
    # user_id can be nil for anonymous users
    # anonymous_id stores a session-based id for anonymous users
    validates :anonymous_id, length: { maximum: 255 }, allow_blank: true
end
