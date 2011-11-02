module Taskrabbit
  autoload :Association, "taskrabbit/association"
  autoload :Config,      "taskrabbit/config"
  autoload :Api,         "taskrabbit/api"
  autoload :Task,        "taskrabbit/task"
  autoload :Account,     "taskrabbit/account"
  autoload :User,        "taskrabbit/user"
  autoload :City,        "taskrabbit/city"
  autoload :Version,     "taskrabbit/version"
  autoload :Collection,  "taskrabbit/collection"
  autoload :Error,       "taskrabbit/error"
  autoload :Proxy,       "taskrabbit/proxy"
  autoload :Transformer, "taskrabbit/transformer"
  autoload :Smash,       "taskrabbit/smash"

  extend Config
end

require 'api_smith'
