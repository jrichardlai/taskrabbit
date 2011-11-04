module Taskrabbit
  autoload :Client,      "taskrabbit/client"
  autoload :Association, "taskrabbit/association"
  autoload :Config,      "taskrabbit/config"
  autoload :Version,     "taskrabbit/version"
  autoload :Error,       "taskrabbit/error"
  autoload :Proxy,       "taskrabbit/proxy"
  autoload :Transformer, "taskrabbit/transformer"
  autoload :Smash,       "taskrabbit/smash"
  autoload :Collection,  "taskrabbit/collection"
  autoload :Api,         "taskrabbit/api"
  autoload :Task,        "taskrabbit/task"
  autoload :Account,     "taskrabbit/account"
  autoload :User,        "taskrabbit/user"
  autoload :City,        "taskrabbit/city"
  autoload :Location,    "taskrabbit/location"

  extend Config
end

require 'api_smith'
