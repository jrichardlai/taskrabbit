module Taskrabbit
  autoload :Config,     "taskrabbit/config"
  autoload :Api,        "taskrabbit/api"
  autoload :Task,       "taskrabbit/task"
  autoload :User,       "taskrabbit/user"
  autoload :Version,    "taskrabbit/version"
  autoload :Collection, "taskrabbit/collection"
  autoload :Error,      "taskrabbit/error"
  autoload :Proxy,      "taskrabbit/proxy"

  extend Config
end

require 'api_smith'
