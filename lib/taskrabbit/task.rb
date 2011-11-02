module Taskrabbit
  class Task < Smash
    property :id
    property :name

    class << self
      def all(scope, options = {})
        path = case scope
               when Api
                 'tasks'
               else
                 "users/#{scope.id}/tasks"
               end
        @found = scope.request('get', path, Api::collection_transformers[self], options)
      end

      def find(api, id)
        # if @found
          # find from users tasks if loaded 
          # @found.detect { |document| document.id == id }
        # else
          api.request('get', "tasks/#{id.to_s}", self)
        # end
      end
      
      def create(api, params)
        api.request('post', "tasks", self, :task => params)
      end
    end
  end
end
