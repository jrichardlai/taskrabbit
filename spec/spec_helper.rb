ENV["RAILS_ENV"] ||= 'test'

require 'rspec'
require 'bundler/setup'
require 'taskrabbit'


Bundler.setup
Bundler.require :default, :test

CASSETTES_PATH = File.join(File.dirname(__FILE__), "support", "cassettes")

module Taskrabbit
  module Config
    remove_const(:DEFAULT_BASE_URI)
    remove_const(:DEFAULT_CLIENT_SECRET)
    DEFAULT_BASE_URI      = 'http://localhost:3000'
    DEFAULT_CLIENT_SECRET = 'euqmQpzV04GmN1dJTY639PdI7eiSjCjI3lKTkPWn'
  end
end
Taskrabbit.reset

RSpec.configure do |config|
end

VCR.config do |c|
  c.cassette_library_dir = CASSETTES_PATH
  c.stub_with :fakeweb
end
