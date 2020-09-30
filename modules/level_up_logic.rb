# frozen_string_literal: true

module LevelUpLogic
  def self.add_points(r_conn, event)
    existing_user = get_existing_user(r_conn, event.user)

    if !existing_user.nil?
      new_points = r_conn.hincrby(event.user.id.to_s, :points, 1)
      check_points(r, new_points, event)
    else
      set_new_user(r_conn, event.user)
    end
  end

  def self.get_existing_user(r_conn, user)
    r_conn.hmget(user.id.to_s, :user_name)[0]
  end

  def self.set_new_user(r_conn, user)
    r_conn.hmset(user.id.to_s, :user_name, user.username, :points, 1, :level, 0)
  end

  def self.check_points(r_conn, new_points, event)
    return unless [5, 50, 100, 500, 1000, 5000, 10_000, 15_000, 50_000, 100_000].include? new_points

    level_up(r_conn, event.user, event)
  end

  def self.level_up(r_conn, user, event)
    new_level = r_conn.hincrby(user.id.to_s, :level, 1)
    notify_level_up(event, new_level)
  end

  def self.notify_level_up(event, new_level)
    username = event.user.username
    begin
      event.channel.send_message("Congrats @#{username} -- you have increased to lvl #{new_level}!")
    rescue StandardError => e
      logger.error e.message
      logger.error e.backtrace
    end
  end
end
