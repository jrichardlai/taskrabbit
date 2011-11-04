module Taskrabbit
  class Error < StandardError
    attr_accessor :response
    
    def initialize(message, response = {})
      @response = response
      super message
    end
  end
end