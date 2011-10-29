module Taskrabbit
  class Api
    include APISmith::Client
    
    class << self
      attr_accessor :client_secret
    end

    attr_accessor :user_token
    
    def initialize(user_token = nil)
      self.user_token = user_token
    end
  end
end