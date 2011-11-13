module Taskrabbit
  class City < Smash
    property :id
    property :name
    property :lat
    property :lng
    property :links
    
    def fetch
      reload('get', "cities/#{id.to_s}")
    end
    
    class << self
      def all(scope, options = {})
        scope.request('get', 'cities', Api::collection_transformers[self], options)
      end
    end
  end
end