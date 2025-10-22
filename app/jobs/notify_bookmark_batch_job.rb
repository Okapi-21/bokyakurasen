class NotifyBookmarkBatchJob < ApplicationJob
  queue_as :default

  # 呼び出し: NotifyBookmarkBatchJob.perform_later   または .perform_now(user_id)
  def perform(user_id = nil)
    scope = user_id ? Bookmark.where(user_id: user_id) : Bookmark.all
    scope = scope.includes(:bookmark_notifications, :user, :bookmarkable)

    scope.find_each do |bookmark|
      begin
        BookmarkNotificationService.new(bookmark).notify_due_reminders
      rescue => e
        Rails.logger.error "[NotifyBookmarkBatchJob] error for bookmark_id=#{bookmark.id}: #{e.class}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
