module Taskrabbit
  class Collection < APISmith::Smash
    property :items
    property :links

    ARRAY_METHODS = %w{first last count size length each}.freeze

    # define array methods for the collection and delegate it to items
    ARRAY_METHODS.each do |method|
      define_method(method) do |*args, &block|
        items.send(method, *args, &block)
      end
    end
  end
end