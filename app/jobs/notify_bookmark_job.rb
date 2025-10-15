class NotifyBookmarkJob < ApplicationJob
  queue_as :default

  def perform(bookmark)
    user = bookmark.user
    Rails.logger.info "[NotifyBookmarkJob] start bookmark_id=#{bookmark.id} user_id=#{user.id} line_user_id=#{user.line_user_id.inspect}"

    # skip if no LINE target
    if user.line_user_id.blank?
      Rails.logger.warn "[NotifyBookmarkJob] skip: no line_user_id for user_id=#{user.id}"
      return
    end

    message = { type: 'text', text: "ブックマークが追加されました: #{bookmark.title}" }

    begin
      # Use LineNotifier (HTTP wrapper) instead of SDK client
      resp = LineNotifier.send_message(user.line_user_id, message[:text])
      Rails.logger.info "[NotifyBookmarkJob] LINE push response: status=#{resp.try(:code)} body=#{resp.try(:body)}"

      unless resp.code.to_i.between?(200,299)
        Rails.logger.error "[NotifyBookmarkJob] push failed: status=#{resp.code} body=#{resp.body}"
        # 必要ならここで raise して ActiveJob の retry_on を使う
      end
    rescue => e
      Rails.logger.error "[NotifyBookmarkJob] LINE push error: #{e.class}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
