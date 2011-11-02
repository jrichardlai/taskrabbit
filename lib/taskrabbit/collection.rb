module Taskrabbit
  class Collection < APISmith::Smash
    property :items
    property :links
    property :error
    
    alias :all :items
    %w{first last count size length each}.each do |method|
      define_method(method) do |*args, &block|
        all.send(method, *args, &block)
      end
    end
  end
end