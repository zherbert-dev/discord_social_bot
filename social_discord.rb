require 'discordrb'
require 'twitter'

bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN'], client_id: ENV['DISCORD_CLIENT_ID'], ignore_bots: true

bot.message(with_text: 'Going live!') do |event|
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV[TWITTER_CONSUMER_KEY]
        config.consumer_secret     = ENV[TWITTER_CONSUMER_SECRET]
        config.access_token        = ENV[TWITTER_ACCESS_TOKEN]
        config.access_token_secret = ENV[TWITTER_ACCESS_TOKEN_SECRET]
    end

    client.update(bot.message.content)
end

bot.run