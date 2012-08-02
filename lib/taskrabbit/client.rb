module Taskrabbit
  module Client
    def self.included(base)
      base.class_eval do
        include APISmith::Client
        include InstanceMethods
        extend  ClassMethods
      end
    end

    module ClassMethods
      def collection_transformers
        @collection_transformers ||= Hash.new do |h, k|
          h[k] = Class.new(Collection).tap do |klass|
            klass.transformer_for :items, k
          end
        end
      end
    end

    module InstanceMethods
      # monkey patch APISmith::Client transform_response to set the api to the object
      def transform_response(response, options)
        transformer = options[:transform] || options[:transformer]
        if transformer
          obj = transformer.call response
          obj.api = self if obj.respond_to?(:api=)
          obj
        else
          response
        end
      end

      # check if an error has occured
      def check_response_errors(response)
        return unless net_http_response = response.response rescue nil
        return if ([Net::HTTPClientError, Net::HTTPServerError] & [net_http_response.class, net_http_response.class.superclass]).empty?
        response_hash = response.to_hash
        error = response_hash.fetch('error') { "#{net_http_response.code} #{net_http_response.message}".strip }

        raise Smash::Error.new(error, response) if response_hash['errors']
        raise Taskrabbit::Error.new(error, response)
      end
    end
  end
end
