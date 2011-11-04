class BasicObject #:nodoc:
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|instance_eval|proxy_|^object_id$)/ }
end unless defined?(BasicObject)

module Taskrabbit
  class Proxy < BasicObject

    COLLECTION_DELEGATE = %w{first last count size length each keys links}.freeze

    def initialize(api, target)
      @api    = api
      @target = target
      @opts   = nil
    end

    def all(options = {})
      return @all if @all and !options.delete(:reload)
      @all = proxy_found(options)
    end
    
    def new(options = {})
      @target.new(options, @api)
    end

    def find(param, options={})
      return all(options) if param == :all
      return @target.find(@api, param) if @target.respond_to?(:find)
    end

    COLLECTION_DELEGATE.each do |method|
      define_method(method) do |*args, &block|
        all(args.pop || {}).send(method, *args, &block)
      end
    end

    def create(args)
      @target.create(@api, args) if @target.respond_to?(:create)
    end

    protected

      def proxy_found(options)
        # Check to see if options have changed
        if @opts == options
          @found ||= load_found(options)
        else
          load_found(options)
        end
      end

    private

      def method_missing(method, *args, &block)
        @target.send(method, *args, &block)
      end

      def load_found(options)
        @opts = options
        @target.all(@api, @opts)
      end

  end
end