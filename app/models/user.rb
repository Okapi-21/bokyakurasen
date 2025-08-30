class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :line ]

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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || "#{auth.uid}@line.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name || "LINEユーザー"
      user.line_user_id = auth.uid
    end
  end
end
