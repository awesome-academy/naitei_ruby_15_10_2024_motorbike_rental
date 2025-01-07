# frozen_string_literal: true

require_relative "boot"

require "rails/all"
require "pagy"
Bundler.require(*Rails.groups)

module NaiteiRuby15102024MotorbikeRental
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = "Hanoi"
  end
end
