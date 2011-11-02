class BasicObject #:nodoc:
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|instance_eval|proxy_|^object_id$)/ }
end unless defined?(BasicObject)

module Taskrabbit
  class Proxy < BasicObject

    def initialize(api, target)
      @api    = api
      @target = target
      @opts   = nil
    end

    def all(options = {})
      return @all if @all and !options.delete(:reload)
      @all = proxy_found(options)
    end

    def find(param, options={})
      return all(options) if param == :all
      return @target.find(@api, param) if @target.respond_to?(:find)
      # return proxy_found(options).detect { |document| document.id == param }
    end

    def first(options = {})
      all(options).first
    end
    
    def last(options = {})
      all(options).last
    end

    # def <<(*objects)
    #   objects.flatten.each do |object|
    #     if obj = object.create
    #       return obj
    #     else
    #       return object
    #     end
    #   end
    # end

    def create(args)
      @target.create(@api, args) if @target.respond_to?(:create)
      # object = @target.new(args.merge({:api => @api}))
      # if obj = object.create
      #   return obj
      # else
      #   return object
      # end
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