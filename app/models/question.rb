class Question < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :description, presence: true, length: { maximum: 65_535 }

    belongs_to :user
    #has_many :choice, dependent: :destroy
    #has_many :question_categories, dependent: :destroy
    #has_many :categories, through: :question_categories
end
