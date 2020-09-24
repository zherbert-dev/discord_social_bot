require 'dotenv'
require 'discordrb'
require 'twitter'

Dotenv.load

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN'], ignore_bots: true

# Monitor a given channel for a message that starts with 'Going live!' and send 
# the message contents to the configured Twitter account
bot.message({in: ENV['CHANNEL_ID'], start_with: 'Going live!'}) do |event|
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end

    client.update(event.message.content)
end

# Bot Commands and Response
# Commands will be messages that start with '!'
bot.message(start_with:'!') do |event|
    cmd = event.message.content.split(' ')[0]
    messages = ["The command you have chosen is unknown to this bot. Please type '!help' to get a list of available commands."]
    case cmd
    when '!help'
        messages = ["Available commands: ", "!help -- returns a list of available commands", "!twitch -- returns ThiccKrust's twitch account URL", "!github -- return ThiccKrust's github page", "!wisdom -- returns random wisdom"]
    when '!twitch'
        messages = ["Find ThiccKrust on Twitch at https://twitch.tv/thicc_krust"]
    when '!github'
        messages = ["Find ThiccKrust on Github at https://github.com/zherbert-dev"]
    when '!wisdom'
        messages = ["This feature is currently under development.", "Here are some words of wisdom anyway:", "Now you understand why Peter Pan didn't want to grow up."]
    end

    messages.each do |msg|
        event.channel.send_message msg
    end
end

bot.run
