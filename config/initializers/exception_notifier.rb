if Rails.env == "production"
  require 'exception_notifier'
  Wargame::Application.config.middleware.use ExceptionNotifier,
      :email_prefix => "[WarGame] ",
      :sender_address => %{"WarGame" <m4kevoid@gmail.com>},
      :exception_recipients => %w{makevoid@gmail.com}
end