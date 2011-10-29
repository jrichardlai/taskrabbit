module Taskrabbit
  autoload :Config,  "taskrabbit/config"
  autoload :Api,     "taskrabbit/api"
  autoload :Task,    "taskrabbit/task"
  autoload :Version, "taskrabbit/version"

  extend Config
end

require 'api_smith'