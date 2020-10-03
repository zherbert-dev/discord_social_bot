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
  @@count = 0
  @@instances = []

  def initialize(name, desc, resp)
    @name = name
    @description = desc
    @response = resp
    @@count += 1
    @@instances << self
  end

  def self.validate_and_respond(command_string, event)
    # remove ! from front of command_string
    command_string[0] = ''
    valid = false
    
    all.each do |ac|
      if ac.instance_variable_get(:@name) == command_string
        valid = true
        respond(ac.instance_variable_get(:@response), event)
      end
    end
    
    respond(Response::UNKNOWN_COMMAND, event) unless valid
  end

  def self.respond(response, event)
    event.channel.send_message response
  end

  def self.all
    @@instances
  end
end
