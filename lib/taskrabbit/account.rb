module Taskrabbit
  class Account < User
    def fetch
      reload('get', "account")
    end
  end
end
