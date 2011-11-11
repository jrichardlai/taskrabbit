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
    property :locations, :transformer => Api::collection_transformers[Location]
    property :links

    has_many :tasks, Task
    has_many :locations, Location

    def fetch
      reload('get', "users/#{id.to_s}")
    end

  end
end
