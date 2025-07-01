class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 5 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # 追加：自分がブックマークしたQuestion一覧
  has_many :bookmarked_questions, through: :bookmarks, source: :bookmarkable, source_type: "Question"

  def own?(question)
    question.user_id == self.id
  end

  def bookmark(question)
    bookmarks.find_or_create_by(bookmarkable: question)
  end

  def unbookmark(question)
    bookmarks.where(bookmarkable: question).destroy_all
  end

  def bookmarked?(question)
    bookmarks.exists?(bookmarkable: question)
  end
end
