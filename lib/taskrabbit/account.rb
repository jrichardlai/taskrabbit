module Taskrabbit
  class Account < User
    property :id
    property :short_name
    property :full_name

    def fetch
      api.request('get', "account", self.class)
    end
  end
end
