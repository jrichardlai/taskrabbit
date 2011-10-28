module Taskrabbit
  class Api
    include APISmith::Client
    
    attr_accessor :token
    
    def initialize(token)
      self.token = token
    end
  end
end