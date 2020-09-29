# frozen_string_literal: true

module DiscordSocialBot
  module LevelUpLogic
    def add_points(r_conn, event)
      user = event.user
      existing_user = r_conn.hmget(user.id.to_s, :user_name)[0]

      if !existing_user.nil?
        new_points = r_conn.hincrby(user.id.to_s, :points, 1)
        check_points(r, user, new_points, event)
      else
        begin
          r_conn.hmset(user.id.to_s, :user_name, event.user.username, :points, 1, :level, 0)
        rescue StandardError => e
          logger.error e.message
          logger.error e.backtrace
        end
      end
    end

    def check_points(r_conn, user, new_points, event)
      unless [LEVEL::ONE, LEVEL::TWO, LEVEL::THREE, LEVEL::FOUR, LEVEL::FIVE,
              LEVEL::SIX, LEVEL::SEVEN, LEVEL::EIGHT, LEVEL::NINE, LEVEL::TEN].include? new_points; return; end

      level_up(r_conn, user, event)
    end

    def level_up(r_conn, user, event)
      new_level = r_conn.hincrby(user.id.to_s, :level, 1)
      notify_level_up(event, new_level)
    end

    def notify_level_up(event, new_level)
      username = event.user.username
      begin
        event.channel.send_message("Congrats @#{username} -- you have increased to lvl #{new_level}!")
      rescue StandardError => e
        logger.error e.message
        logger.error e.backtrace
      end
    end
  end
end
