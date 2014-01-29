require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module OdataProviderExampleRb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.after_initialize do
      twitter_config = YAML.load_file("#{Rails.root}/config/twitter.yml")
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = twitter_config['consumer_key']
        config.consumer_secret     = twitter_config['consumer_secret']
        config.access_token        = twitter_config['access_token']
        config.access_token_secret = twitter_config['access_token_secret']
      end
      OData::Edm::DataServices.schemas << OData::TwitterSchema::Base.new("Twitter", client)
    end
  end
end

