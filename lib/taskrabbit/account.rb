module Taskrabbit
  class Account < User
    def fetch
      api.request('get', "account", self.class)
    end
  end
end
