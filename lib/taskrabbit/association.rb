module Taskrabbit
  module Association
    def self.included(base)
      base.const_set('PATHS', {})
      base.class_eval do
        include InstanceMethods
        extend  ClassMethods
      end
    end
    
    module ClassMethods
      # define has many that will proxy the association to the class
      # if the association has been loaded previously, no proxy will be used
      def has_many(association, klass, options = {})
        class_eval <<-"END"
        def #{association}
          return self[:#{association}] if property_present?(:#{association})
          @#{association} ||= Proxy.new(self, #{klass})
        end
        END
        self::PATHS[klass] = options[:on]
      end
    end
    
    module InstanceMethods
      
      # return the association path on the api that correspond to the class
      def association_path(klass)
        case paths[klass]
        when String
          paths[klass]
        when Proc
          paths[klass][self]
        else
          raise Error.new("Action not defined for #{self.class} on the #{klass} association")
        end
      end
      
      private

      # check if the property has been loaded
      def property_present?(property)
        respond_to?(:loaded) and loaded and self.class.property?(property) and self[property]
      end
      
      def paths
        self.class::PATHS
      end
      
    end
  end
end