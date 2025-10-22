class Category < ApplicationRecord
  has_many :question_categories, dependent: :destroy
  has_many :questions, through: :question_categories
  validates :name, presence: true, uniqueness: true
end
