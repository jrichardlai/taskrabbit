module Taskrabbit
  module Config
    DEFAULT_BASE_URI  = 'http://taskrabbit.com/'
    DEFAULT_END_POINT = 'api/v1'
    
    VALID_OPTIONS_KEYS = [
      :base_uri,
      :end_point
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      puts "extension"
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
      self.base_uri           = DEFAULT_BASE_URI
      self.end_point          = DEFAULT_END_POINT
      self
    end
    
  end
end