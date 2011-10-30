module Taskrabbit
  module Config
    DEFAULT_BASE_URI      = 'http://taskrabbit.com'
    DEFAULT_END_POINT     = 'api/v1'
    DEFAULT_CLIENT_SECRET = nil

    VALID_OPTIONS_KEYS = [
      :base_uri,
      :client_secret,
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
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end
    
    # Reset all configuration options to defaults
    def reset
      self.base_uri      = DEFAULT_BASE_URI
      self.endpoint      = DEFAULT_END_POINT
      self.client_secret = DEFAULT_CLIENT_SECRET
      self
    end
    
  end
end