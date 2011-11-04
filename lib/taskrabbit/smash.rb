module Taskrabbit
  class Smash < APISmith::Smash
    include Transformer
    include Association
    attr_accessor :api
    attr_accessor :loaded
    
    property :errors
    property :error
    
    class << self
      def find(api, id)
        raise Taskrabbit::Error.new("Couldn't find #{self} without an ID") if id.nil?
        new({:id => id}, api)
      end
    end

    class Error < Taskrabbit::Error
    end

    def initialize(options = {}, api = nil)
      self.api    = api
      self.loaded = false
      super options
    end

    def request(*args)
      api.request *args
    end

    def valid?
      errors.nil? and error.nil?
    end

    def clear_errors
      %w{error errors}.map { |k| self.delete(k) }
    end

    def reload(method, path, options = {})
      self.loaded = true
      response = api.request(method, path, self.class, options)
      self.merge!(response)
      clear_errors
      true
    rescue Smash::Error => e
      self.merge!(e.response) if e.response.is_a?(Hash)
      false
    end
    
    def fetch; end

    def [](property)
      value = nil
      return value unless (value = super(property)).nil?
      if api and !loaded
        # load the object if trying to access a property
        self.loaded = true
        fetch
      end
      super(property)
    end
  end
end