module Taskrabbit
  class User < Smash
    property :id
    property :short_name
    property :first_name
    property :full_name
    property :display_name
    property :runner, :default => false
    property :email
    property :mobile_phone
    property :home_phone
    property :tasks, :transformer => Api::collection_transformers[Task]
    property :city, :transformer => City
    property :zip_code
    property :locations, :transformer => Api::collection_transformers[Location]
    property :links

    has_many :tasks, Task, :on => lambda { |user| "users/#{user.id}/tasks" }
    has_many :locations, Location, :on => lambda { |user| "users/#{user.id}/locations" }

    def fetch
      reload('get', "users/#{id.to_s}")
    end

  end
end
