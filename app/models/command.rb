# frozen_string_literal: true

class Command
  module Response
    UNKNOWN_COMMAND = "The command you have chosen is unknown to this bot.
                        \nPlease type '!help' to get a list of available commands."
    NOT_AUTHORIZED = 'WOAH THERE BUDDY! You are NOT AUTHORIZED to use this command!'
  end
  
  @name = ''
  @description = ''
  @response = ''

  def initialize(name, desc, resp)
    @name = name
    @description = desc
    @response = resp
  end

  def validate_and_respond(command_string, available_commands, event)
    # remove ! from front of command_string
    command_string[0] = ''
    valid = false

    available_commands.each do |ac|
      if ac.name == command_string
        valid = true
        respond(ac.response, event)
      end
    end
    respond(Response::UNKNOWN_COMMAND, event) unless valid
  end

  def respond(response, event)
    event.channel.send_message response
  end
end
