class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :bookmarkable, polymorphic: true

    has_many :bookmark_notifications, dependent: :destroy

    validates :user_id, uniqueness: { scope: [ :bookmarkable_type, :bookmarkable_id ] }
end
