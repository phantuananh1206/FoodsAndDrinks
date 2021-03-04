require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RubyOe39FoodAndDrink
  class Application < Rails::Application
    config.load_defaults 6.0
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.factory_bot.definition_file_paths = ["custom/factories"]
    config.active_job.queue_adapter = :delayed_job
    Rails.application.config.session_store :active_record_store
  end
end
