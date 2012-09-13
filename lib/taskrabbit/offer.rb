module Taskrabbit
  class Offer < Smash
    property :id
    property :charge_price
    property :comment
    property :state
    property :runner_id
    
    class << self
      def all(scope, options = {})
        scope.request('get', scope.association_path(self), Api::collection_transformers[self], options)
      end
    end
  end
end