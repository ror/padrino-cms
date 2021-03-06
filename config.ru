#!/usr/bin/env rackup
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.

require File.expand_path("../config/boot.rb", __FILE__)

# use ruby standard logger because padrino logger has odd error in my production environment.
require 'logger'
class ::Logger; alias_method :write, :<<; end

if ENV['RACK_ENV'] == 'production'
  logger = ::Logger.new("log/production.log")
  logger.level = ::Logger::WARN
  use Rack::CommonLogger, logger
end

#
# fixme 修改产品环境下的配置
# Supports CORS via Rack::CORS, part of the rack-cors gem.
#
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
  end
end

# Api:https://github.com/LTe/grape-rabl
require 'grape/rabl'
use Rack::Config do |env|
  env['api.tilt.root'] = PADRINO_ROOT + '/api/views'
end

run Padrino.application
