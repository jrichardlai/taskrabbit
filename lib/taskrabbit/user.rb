module Taskrabbit
  class User < Smash
    property :id
    property :short_name
    property :first_name
    property :full_name
    property :display_name
    property :tasks, :transformer => Api::collection_transformers[Task]
    property :city, :transformer => City
    property :zip_code
    property :locations
    property :links

    def fetch
      api.request('get', "users/#{id.to_s}", self.class)
    end

    def tasks
      return self[:tasks] if loaded and self[:tasks]
      @tasks ||= Proxy.new(self, Task)
    end

  end
end
