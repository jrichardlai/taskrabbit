module Taskrabbit
  module Transformer
    TIME_TRANSFORMER = lambda { |v| Time.at(v.to_i) }
  end
end
