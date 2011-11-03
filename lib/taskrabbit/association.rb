module Taskrabbit
  module Association
    def has_many(association, klass)
      class_eval <<-"END"
      def #{association}
        @#{association} ||= Proxy.new(self, #{klass})
      end
      END
    end
  end
end