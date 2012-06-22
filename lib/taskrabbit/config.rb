module Taskrabbit
  module Config
    DEFAULT_BASE_URI      = 'http://www.taskrabbit.com'
    DEFAULT_END_POINT     = 'api/v1'
    DEFAULT_API_SECRET = nil

    VALID_OPTIONS_KEYS = [
      :base_uri,
      :api_secret,
      :endpoint
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      {}.tap do |options|
        VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      end
    end
    
    # Reset all configuration options to defaults
    def reset
      self.tap do |c|
        c.base_uri      = DEFAULT_BASE_URI
        c.endpoint      = DEFAULT_END_POINT
        c.api_secret = DEFAULT_API_SECRET
      end
    end
    
  end
end