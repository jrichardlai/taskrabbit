module Taskrabbit
  class Api
    include APISmith::Client

    attr_accessor :user_token
    attr_accessor *Config::VALID_OPTIONS_KEYS

    def self.collection_transformers
      @collection_transformers ||= Hash.new do |h, k|
        h[k] = Class.new(Collection).tap do |klass|
          klass.transformer_for :items, k
        end
      end
    end

    def initialize(user_token = nil, attrs = {})
      attrs = Taskrabbit.options.merge(attrs)
      # set the configuration for the api
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
      self.user_token = user_token if user_token
    end

    def request_params(type)
      {
        :transform => Api::collection_transformers[type],
        :extra_request => {
          :headers => {'X-Client-Application' => client_secret.to_s},
          :endpoint => endpoint.to_s,
          :base_uri => base_uri.to_s
        }
      }
    end

    def check_response_errors(response)
      if response.is_a?(Hash) and (error = response['error'])
        raise Taskrabbit::Error.new(error)
      end
    end

    def base_query_options
      {:output => 'json'}
    end

    def tasks
      get 'tasks', request_params(Task)
    end
  end
end
