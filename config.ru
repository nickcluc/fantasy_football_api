# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack/cors'

run Rails.application

use Rack::Cors do

  # allow all origins in development
  allow do
    origins '*'
    resource '*',
        :headers => :any,
        :methods => [:get, :post, :delete, :put, :patch, :options, :head]
  end
end
