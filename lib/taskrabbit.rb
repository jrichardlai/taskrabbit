module Taskrabbit
  # Your code goes here...
  autoload :Api,     "taskrabbit/api"
  autoload :Task,    "taskrabbit/task"
  autoload :Version, "taskrabbit/version"
end

require 'api_smith'