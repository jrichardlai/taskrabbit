module Taskrabbit
  class Task < APISmith::Smash
    property :id
    property :name

    class << self
      def all(api, options = {})
        @found = api.request('get', 'tasks', Api::collection_transformers[self], options)
      end

      def find(id, api)
        # if @found
          # find from users tasks if loaded 
          # @found.detect { |document| document.id == id }
        # else
          api.request('get', "tasks/#{id.to_s}", self)
        # end
      end
    end
  end
end
