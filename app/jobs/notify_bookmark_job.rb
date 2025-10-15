class NotifyBookmarkJob < ApplicationJob
  queue_as :default

  def perform(user_id = nil)
    scope = user_id ? Bookmark.where(user_id: user_id) : Bookmark.all

    scope.includes(:bookmark_notifications).find_each do |bookmark|
      BookmarkNotificationService.new(bookmark).notify_due_reminders
    end
  end

  def perform(bookmark)
    user = bookmark.user
    Rails.logger.info "[NotifyBookmarkJob] start bookmark_id=#{bookmark.id} user_id=#{user.id} line_user_id=#{user.line_user_id.inspect}"

    message = { type: 'text', text: "ブックマークが追加されました: #{bookmark.title}" }

    begin
      resp = line_client.push_message(user.line_user_id, message)
      Rails.logger.info "[NotifyBookmarkJob] LINE push response: status=#{resp.code} body=#{resp.body}"
    rescue => e
      Rails.logger.error "[NotifyBookmarkJob] LINE push error: #{e.class}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
