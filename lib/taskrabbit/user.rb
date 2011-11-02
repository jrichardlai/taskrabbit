module Taskrabbit
  class User < Smash
    property :id
    property :short_name
    property :full_name

    has_many :tasks, Task

    def fetch
      api.request('get', "users/#{id.to_s}", self.class)
    end
  end
end
