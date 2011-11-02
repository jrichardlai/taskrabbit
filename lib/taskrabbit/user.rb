module Taskrabbit
  class User < Smash
    property :id
    property :short_name
    property :full_name

    def fetch
      api.request('get', "users/#{id.to_s}", self.class)
    end

    def tasks
      @tasks ||= Proxy.new(self, Task)
    end
  end
end
