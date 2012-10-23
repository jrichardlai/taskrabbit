module Taskrabbit
  class Task < Smash
    property :id
    property :name
    property :user, :transformer => User
    property :runner, :transformer => User
    property :runners, :transformer => Api::collection_transformers[User]
    property :named_price
    property :charge_price
    property :cost_in_cents
    property :number_runners_to_fill
    property :links
    property :state_label
    property :geography_id
    property :city, :transformer => City
    property :description, :default => ''
    property :private_description, :default => ''
    property :private_runner, :default => false
    property :virtual, :default => false
    property :state
    property :assignment_type
    property :runner_type
    property :complete_by_time, :transformer => TIME_TRANSFORMER
    property :state_changed_at, :transformer => TIME_TRANSFORMER
    property :assign_by_time, :transformer => TIME_TRANSFORMER
    property :location_visits, :transformer => Api::collection_transformers[Location]
    property :offers, :transformer => Api::collection_transformers[Offer]
    property :other_locations_attributes
    property :uploaded_photos_attributes
    property :uploaded_sounds_attributes

    class << self
      def all(scope, options = {})
        scope.request('get', scope.association_path(self), Api::collection_transformers[self], options_with_class_includes(options))
      end
      
      def create(api, params)
        task = api.tasks.new(params)
        task.save
        task
      end

      def options_with_class_includes(options = {})
        options.merge(:extra_query => {:include => {:task => properties.to_a}})
      end
    end
    
    def fetch
      reload('get', "tasks/#{id.to_s}") unless id.nil?
    end

    def save
      if id.nil?
        reload('post', "tasks", :task => self.to_hash)
      else
        reload('put', "tasks/#{id.to_s}", self.to_hash)
      end
    end

    def update_attributes(attributes)
      attributes.each_pair do |key, value|
        self.send("#{key}=", value)
      end
      save
    end

    def new_record?
      !id
    end

    def delete!
      reload('delete', "tasks/#{id.to_s}")
    end

    def reload(method, path, options = {})
      options = self.class.options_with_class_includes(options) if method.to_s == 'get'
      super(method, path, options)
    end
  end
end
