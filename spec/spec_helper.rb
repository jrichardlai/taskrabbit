ENV["RAILS_ENV"] ||= 'test'

require 'rspec'
require 'bundler/setup'
require 'taskrabbit'

Bundler.setup
Bundler.require :default, :test

RSpec.configure do |config|
end