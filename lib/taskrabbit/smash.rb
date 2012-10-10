module Taskrabbit
  class Smash < APISmith::Smash
    include Transformer
    include Association
    attr_accessor :api
    attr_accessor :loaded
    
    property :errors
    property :links
    property :error
    
    class << self
      def find(api, id)
        raise Taskrabbit::Error.new("Couldn't find #{self} without an ID") if id.nil?
        new({:id => id}, api)
      end

      def filtered_options(options)
        filtered_hash = {}
        options.each_pair do |key, value|
          filtered_hash[key] = 
          case value
          when Time
            value.to_i
          when Hash
            filtered_options(value)
          else
            value
          end
        end
        filtered_hash
      end
    end

    class Error < Taskrabbit::Error
    end

    def initialize(options = {}, api = nil)
      self.api    = api
      self.loaded = false
      super options
    end

    # do a request through the api instance
    def request(*args)
      api.request *args
    end

    # check if the object is valid
    def valid?
      errors.nil? and error.nil?
    end

    def redirect_url
      links["redirect"] if links
    end

    def redirect?
      !!redirect_url
    end

    # reload the object after doing a query to the api
    def reload(method, path, options = {})
      self.loaded = true
      response = request(method, path, self.class, Smash::filtered_options(options))
      self.merge!(response)
      clear_errors
      !redirect?
    rescue Smash::Error => e
      self.merge!(e.response) if e.response.is_a?(Hash)
      false
    end
    
    # fetch the object
    def fetch; end

    # get the property from the hash
    # if the value is not set and the object has not been loaded, try to load it
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

    private

    # remove the errors from the object
    def clear_errors
      %w{error errors}.map { |k| self.delete(k) }
    end
  end
end