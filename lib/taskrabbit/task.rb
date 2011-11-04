module Taskrabbit
  class Task < Smash
    property :id
    property :name
    property :user, :transformer => User
    property :runner, :transformer => User
    property :named_price
    property :cost_in_cents
    property :links
    property :state_label
    property :city_id
    property :city, :transformer => City
    property :state
    property :complete_by_time, :transformer => TIME_TRANSFORMER
    property :state_changed_at, :transformer => TIME_TRANSFORMER
    property :assign_by_time, :transformer => TIME_TRANSFORMER
    property :locations, :transformer => Api::collection_transformers[Location]

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
      
      def create(api, params)
        api.request('post', "tasks", self, :task => params)
      end
    end
    
    def fetch
      reload('get', "tasks/#{id.to_s}")
    end

    def save
      if id.nil?
        reload('post', "tasks", :task => self.to_hash)
      else
        reload('put', "tasks/#{id.to_s}", self.to_hash)
      end
    end

    def delete!
      reload('delete', "tasks/#{id.to_s}")
    end
  end
end
