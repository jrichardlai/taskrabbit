ENV["RAILS_ENV"] ||= 'test'

require 'rspec'
require 'bundler/setup'
require 'taskrabbit'

Bundler.setup
Bundler.require :default, :test

CASSETTES_PATH = File.join(File.dirname(__FILE__), "support", "cassettes")

Taskrabbit.configure do |config|
  config.base_uri = 'http://localhost:3000'
end

RSpec.configure do |config|
end

VCR.config do |c|
  c.cassette_library_dir = CASSETTES_PATH
  c.stub_with :fakeweb
end
