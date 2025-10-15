require 'net/http'
require 'uri'
require 'json'
require 'ostruct'

class LineNotifier
  PUSH_URI = URI.parse('https://api.line.me/v2/bot/message/push')

  def self.send_message(line_user_id, message)
    token = ENV['LINE_CHANNEL_TOKEN']
    return nil if token.to_s.strip.empty? || line_user_id.to_s.strip.empty?

    req = Net::HTTP::Post.new(PUSH_URI)
    req['Content-Type'] = 'application/json'
    req['Authorization'] = "Bearer #{token}"
    req.body = {
      to: line_user_id,
      messages: [{ type: 'text', text: message }]
    }.to_json

    res = Net::HTTP.start(PUSH_URI.host, PUSH_URI.port, use_ssl: true) do |http|
      http.request(req)
    end

    Rails.logger.info "[LineNotifier] LINE API response code=#{res.code} body=#{res.body}"
    OpenStruct.new(code: res.code, body: res.body)
  rescue => e
    Rails.logger.error "[LineNotifier] error: #{e.class}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    nil
  end
end
