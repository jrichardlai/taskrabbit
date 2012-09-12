ENV["RAILS_ENV"] ||= 'test'

require 'rspec'
require 'bundler/setup'
require 'taskrabbit'


Bundler.setup
Bundler.require :default, :test

CASSETTES_PATH = File.join(File.dirname(__FILE__), "support", "cassettes")
TR_USERS = {
  :with_card    => {:secret => ENV['USER_WITH_CARD'], :id => ENV['USER_WITH_CARD_ID'].to_i },
  :without_card => {:secret => ENV['USER_WITHOUT_CARD'], :id => ENV['USER_WITHOUT_CARD_ID'].to_i },
}

module Taskrabbit
  module Config
    remove_const(:DEFAULT_BASE_URI)
    remove_const(:DEFAULT_API_SECRET)
    DEFAULT_BASE_URI   = 'https://taskrabbitdev.com'
    DEFAULT_API_SECRET = ENV['API_SECRET']
  end
end
Taskrabbit.reset

RSpec.configure do |config|
end

VCR.config do |c|
  c.cassette_library_dir = CASSETTES_PATH
  c.filter_sensitive_data('<API_SECRET>')        { ENV['API_SECRET'] }
  c.filter_sensitive_data('<API_KEY>')           { ENV['API_KEY'] }
  c.filter_sensitive_data('<USER_WITH_CARD>')    { ENV['USER_WITH_CARD'] }
  c.filter_sensitive_data('<USER_WITHOUT_CARD>') { ENV['USER_WITHOUT_CARD'] }
  c.stub_with :fakeweb
end
