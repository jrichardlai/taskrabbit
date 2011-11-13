module Taskrabbit
  module Client
    def self.included(base)
      base.class_eval do
        include APISmith::Client
        include InstanceMethods
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
        return unless [Net::HTTPClientError, Net::HTTPServerError].include?(net_http_response.class.superclass)

        response_hash = response.to_hash
        error = response_hash.fetch('error') { "#{net_http_response.code} #{net_http_response.message}" }

        raise Smash::Error.new(error, response) if response_hash['errors']
        raise Taskrabbit::Error.new(error, response)
      end
    end
  end
end
