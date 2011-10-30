module Taskrabbit
  class Collection < APISmith::Smash
    property :items
    property :links
    property :error
    
    alias :all :items
    
    def first
      all.first
    end
    
    def last
      all.last
    end
  end
end