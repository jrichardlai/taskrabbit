module Taskrabbit
  class Location < Smash
    property :id
    property :name
    property :address
    property :approximate_radius
    property :city
    property :zip
    property :partial
    property :state
    property :complete

    class << self
      def all(scope, options = {})
        path = case scope
               when User
                 "users/#{scope.id}/locations"
               else
                 raise Error.new("Action not defined")
               end
        @found = scope.request('get', path, Api::collection_transformers[self], options)
      end
    end
  end
end