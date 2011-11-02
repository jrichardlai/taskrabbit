module Taskrabbit
  class Smash < APISmith::Smash
    class << self
      def find(api, id)
        raise Taskrabbit::Error.new("Couldn't find #{self} without an ID") if id.nil?
        obj = new({:id => id}, api)
      end
    end

    attr_accessor :api
    attr_accessor :loaded

    def initialize(options = {}, api = nil)
      self.api    = api
      self.loaded = false
      super options
    end

    def request(*args)
      api.request *args
    end
    
    def load
      self.loaded = true
      instance = fetch
      self.merge!(instance.to_hash)
    end
    
    def [](property)
      value = nil
      return value unless (value = super(property)).nil?
      if api and !loaded
        # load the object if trying to access a property
        load
      end
      super(property)
    end
  end
end