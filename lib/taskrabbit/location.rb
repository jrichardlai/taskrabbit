module Taskrabbit
  class Location < Smash
    property :id
    property :name
    property :address
    property :approximate_radius
    property :city
    property :location_id
    property :zip
    property :partial
    property :state
    property :complete

    class << self
      def all(scope, options = {})
        scope.request('get', scope.association_path(self), Api::collection_transformers[self], options)
      end
    end
  end
end