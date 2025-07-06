class NotifyBookmarkJob < ApplicationJob
  queue_as :default

  def perform(user_id = nil)
    scope = user_id ? Bookmark.where(user_id: user_id) : Bookmark.all

    scope.includes(:bookmark_notifications).find_each do |bookmark|
      BookmarkNotificationService.new(bookmark).notify_due_reminders
    end
  end
end
