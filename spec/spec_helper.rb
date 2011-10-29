ENV["RAILS_ENV"] ||= 'test'

require 'rspec'
require 'bundler/setup'
require 'taskrabbit'

Bundler.setup
Bundler.require :default, :test

RSpec.configure do |config|
end

VCR.config do |c|
  c.cassette_library_dir = CASSETTES_PATH
  c.stub_with :fakeweb
end
