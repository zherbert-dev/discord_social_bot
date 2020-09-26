#require_relative 'giphy_logic'

def welcome_new_member(event)
    username = get_username_from_message_mentions
    unless username.empty?
        message = "Welcome to Pizza Planet #{username}, glad to have you!! Grab yourself a hot slice and hangout for a while!"
        event.channel.send_message(message)
    end
end

def validate_command_and_respond(event, command)
    messages = nil

    case command
    when '!help'
        messages = ["Available commands: ", "!help -- returns a list of available commands", "!twitch -- returns ThiccKrust's twitch account URL", "!github -- return ThiccKrust's github page", "!wisdom -- returns random wisdom", "!rolld20 -- rolls a D20 die"]
    when '!twitch'
        messages = ["Find ThiccKrust on Twitch at https://twitch.tv/thicc_krust"]
    when '!github'
        messages = ["Find ThiccKrust on Github at https://github.com/zherbert-dev"]
    when '!wisdom'
        messages = ["This feature is currently under development.", "Here are some words of wisdom anyway:", "Now you understand why Peter Pan didn't want to grow up."]
    when '!rolld20'
        value = roll_d_twenty
        messages = ["You rolled a #{value}!"]
    # when '!randomGif'
    #     messages = []
    else
        messages = ["The command you have chosen is unknown to this bot. Please type '!help' to get a list of available commands."]
    end

    respond_to_command(event, command, messages)
end

def respond_to_command(event, command, messages)
    # case command
    # when '!randomGif'
    #     query = "debug"
    #     get_random_gif(query)
    # else
    #     messages.each do |msg|
    #         event.channel.send_message msg
    #     end
    # end

    messages.each do |msg|
        event.channel.send_message msg
    end
end

def roll_d_twenty
    value = rand(1..20)
end

def get_username_from_message_mentions (event)
    event.message.mentions[0].username || nil
end