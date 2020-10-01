# frozen_string_literal: true

class Command
  @name = ''
  @description = ''
  @response = ''

  def initialize(name, desc, resp)
    @name = name
    @description = desc
    @response = resp
  end

  def respond(event)
  end
end
