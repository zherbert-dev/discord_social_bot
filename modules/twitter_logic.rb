# frozen_string_literal: true

module DiscordSocialBot
  module TwitterLogic
    def twitter_client
      Twitter::REST::Client.new do |config|
        config.consumer_key        = CONFIG['twitter_consumer_key'].to_s
        config.consumer_secret     = CONFIG['twitter_consumer_secret'].to_s
        config.access_token        = CONFIG['twitter_access_token'].to_s
        config.access_token_secret = CONFIG['twitter_access_token_secret'].to_s
      end
    end

    def create_twitter_post(client, message)
      client.update(message)
    end
  end
end
