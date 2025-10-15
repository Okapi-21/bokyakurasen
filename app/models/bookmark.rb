class Bookmark < ApplicationRecord
    belongs_to :user
    belongs_to :bookmarkable, polymorphic: true

    has_many :bookmark_notifications, dependent: :destroy

    validates :user_id, uniqueness: { scope: [ :bookmarkable_type, :bookmarkable_id ] }

    # 新規作成時に非同期で通知ジョブをキック
    after_create :enqueue_notify_job

    def title
        return "" unless bookmarkable

        if bookmarkable.respond_to?(:title)
            bookmarkable.title.to_s
        elsif bookmarkable.respond_to?(:name)
            bookmarkable.name.to_s
        else
            ""
        end
    end

    private

    def enqueue_notify_job
        NotifyBookmarkJob.perform_later(self)
    end
end
