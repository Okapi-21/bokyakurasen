class Question < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :description, presence: true, length: { maximum: 65_535 }

    belongs_to :user

    belongs_to :parent, class_name: "Question", optional: true
    has_many :children, class_name: "Question", foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

    has_many :choices, dependent: :destroy, inverse_of: :question
    accepts_nested_attributes_for :choices, allow_destroy: true
    has_many :answers, dependent: :destroy

    accepts_nested_attributes_for :children, allow_destroy: true
    accepts_nested_attributes_for :choices, allow_destroy: true
  # has_many :question_categories, dependent: :destroy
  # has_many :categories, through: :question_categories
end
