module Taskrabbit
  class Smash < APISmith::Smash

    class << self
      def find(api, id)
        new({:id => id}, api)
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

    # load the object if trying to access a property
    def [](property)
      if api and !loaded
        self.loaded = true
        instance = fetch
        self.merge!(instance.to_hash)
      end
      super(property)
    end
  end
end