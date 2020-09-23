require 'discordrb'
require 'twitter'

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], ignore_bots: true
bot.message({in: ENV['CHANNEL_ID'], start_with: 'Going live!'}) do |event|
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV[TWITTER_CONSUMER_KEY]
        config.consumer_secret     = ENV[TWITTER_CONSUMER_SECRET]
        config.access_token        = ENV[TWITTER_ACCESS_TOKEN]
        config.access_token_secret = ENV[TWITTER_ACCESS_TOKEN_SECRET]
    end

    client.update(event.message.content)
end

bot.run