module Taskrabbit
  class City < Smash
    property :id
    property :name
    property :lat
    property :lng
    property :links
    
    def fetch
      api.request('get', "cities/#{id.to_s}", self.class)
    end
    
    class << self
      def all(scope, options = {})
        @found = scope.request('get', 'cities', Api::collection_transformers[self], options)
      end
    end
  end
end