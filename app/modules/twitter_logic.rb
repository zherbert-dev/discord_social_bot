# frozen_string_literal: true

module TwitterLogic
  require 'yaml'
  CONFIG = YAML.load_file(File.join('app', 'config.yaml'))

  def self.twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = CONFIG['twitter_consumer_key'].to_s
      config.consumer_secret     = CONFIG['twitter_consumer_secret'].to_s
      config.access_token        = CONFIG['twitter_access_token'].to_s
      config.access_token_secret = CONFIG['twitter_access_token_secret'].to_s
    end
  end

  def self.create_twitter_post(client, message)
    client.update(message)
  end
end
