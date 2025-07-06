require "line/bot"

class LineNotifier
  def self.send_message(line_user_id, message)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    message_params = {
      type: "text",
      text: message
    }

    response = client.push_message(line_user_id, message_params)
    puts "LINE API response code: #{response.code}"
    puts "LINE API response body: #{response.body}"
    response.code == "200"
  end
end
