class BookmarkNotificationService
  # 復習間隔の設定
  REVIEW_SCHEDULE_DAYS = [ 1, 3, 7, 14, 30 ].freeze

  # インスタンス変数（初期設定）
  def initialize(bookmark)
    @bookmark = bookmark
  end

  # リマインド設定
  def notify_due_reminders
    REVIEW_SCHEDULE_DAYS.each_with_index do |days, idx|
      scheduled_time = @bookmark.created_at + days.days
      notification_number = idx + 1

      if Time.current >= scheduled_time && !notified?(notification_number)
        resp = send_line_notification(notification_number)
        if resp && resp.respond_to?(:code) && resp.code.to_i.between?(200,299)
          record_notification(notification_number)
        else
          Rails.logger.error "[BookmarkNotificationService] notify failed for bookmark_id=#{@bookmark.id} notification_number=#{notification_number} resp=#{resp.inspect}"
        end
      end
    end
  end

  private

  def notified?(notification_number)
    @bookmark.bookmark_notifications.exists?(notification_number: notification_number)
  end

  # メッセージ内容の作成
  def send_line_notification(notification_number)
    return unless @bookmark.user&.line_user_id.present?

    target_title = @bookmark.title.presence || "（タイトルなし）"
    message = "【復習#{notification_number}回目】「#{target_title}」を復習しましょう！"

    begin
      resp = LineNotifier.send_message(@bookmark.user.line_user_id, message)
      Rails.logger.info "[BookmarkNotificationService] LINE push response: status=#{resp.try(:code)} body=#{resp.try(:body)}"
      resp
    rescue => e
      Rails.logger.error "[BookmarkNotificationService] LINE push error: #{e.class}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      nil
    end
  end

  def record_notification(notification_number)
    @bookmark.bookmark_notifications.create!(
      notification_number: notification_number,
      sent_at: Time.current
    )
  end
end
