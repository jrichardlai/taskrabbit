module Taskrabbit
  module Client
    def self.included(base)
      base.class_eval do
        include APISmith::Client
        include InstanceMethods
      end
    end

    module InstanceMethods
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

      def check_response_errors(response)
        if response and response.respond_to?(:response)
          case response.response
          when Net::HTTPClientError, Net::HTTPServerError
            error = "#{response.response.code} #{response.response.message}"
            if response.is_a?(Hash)
              error = response['error']
              # if errors key is present then it's a validation error
              raise Smash::Error.new(error, response) if response['errors']
            end
            raise Taskrabbit::Error.new(error, response)
          end
        end
      end
    end
  end
end
