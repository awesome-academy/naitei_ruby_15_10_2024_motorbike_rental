# frozen_string_literal: true

# The Application class is the central configuration class for the Rails application.
# It is responsible for initializing various settings and configurations that apply
# across the entire application, including engines, railties, and defaults. This class
# serves as the foundation for the application setup, and can be extended or customized
# in specific environments using configuration files in config/environments.
#
# You can configure settings like time zone, eager loading paths, and other application
# specific configurations here.

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NaiteiRuby15102024MotorbikeRental
  # The Application class initializes the configuration defaults for the application.
  # It can be further customized for different environments in config/environments.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
