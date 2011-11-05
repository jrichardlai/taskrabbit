module Taskrabbit
  module Association
    
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend  ClassMethods
      end
    end
    
    module ClassMethods
      # define has many that will proxy the association to the class
      # if the association has been loaded previously, no proxy will be used
      def has_many(association, klass)
        class_eval <<-"END"
        def #{association}
          return self[:#{association}] if property_present?(:#{association})
          @#{association} ||= Proxy.new(self, #{klass})
        end
        END
      end
    end
    
    module InstanceMethods
      # check if the property has been loaded
      def property_present?(property)
        respond_to?(:loaded) and loaded and self.class.property?(property) and self[property]
      end
    end
  end
end