class BookmarkNotificationService
  #復習間隔の設定
  REVIEW_SCHEDULE_DAYS = [1, 3, 7, 14, 30].freeze

  #インスタンス変数（初期設定）
  def initialize(bookmark)
    @bookmark = bookmark
  end

  #リマインド設定
  def notify_due_reminders
    REVIEW_SCHEDULE_DAYS.each_with_index do |days, idx|
        scheduled_time = @bookmark.created_at + days.days
        notification_number = idx + 1

        if Time.current >= scheduled_time && !notified?(notification_number)
            send_line_notification(notification_number)
            record_notification(notification_number)
        end
    end
  end

  private

  def notified?(notification_number)
    @bookmark.bookmark_notifications.exists?(notification_number: notification_number)
  end

  #メッセージ内容の作成
  def send_line_notification(notification_number)
    message = "【復習#{notification_number}回目】「#{@bookmark.bookmarkable.title}」を復習しましょう！"
  LineNotifier.send_message(@bookmark.user.line_user_id, message)
  end

  def record_notification(notification_number)
    @bookmark.bookmark_notifications.create!(
      notification_number: notification_number,
      sent_at: Time.current
    )
  end
end