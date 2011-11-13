module Taskrabbit
  class Api
    include Client
    include Association

    attr_accessor :user_token
    attr_accessor *Config::VALID_OPTIONS_KEYS

    def self.collection_transformers
      @collection_transformers ||= Hash.new do |h, k|
        h[k] = Class.new(Collection).tap do |klass|
          klass.transformer_for :items, k
        end
      end
    end

    has_many :users, User
    has_many :tasks, Task, :on => 'tasks'
    has_many :cities, City

    def account
      @account ||= Account.new({}, self)
    end

    def initialize(user_token = nil, attrs = {})
      attrs = Taskrabbit.options.merge(attrs)
      # set the configuration for the api
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
      self.user_token = user_token if user_token
    end

    def request_params(transformer, options = {})
      {
        :transform => transformer,
        :extra_body => options,
        :extra_request => {
          :headers => {
            'X-Client-Application' => client_secret.to_s, 
            'Authorization' => "OAuth #{user_token.to_s}"
          },
          :endpoint => endpoint.to_s,
          :base_uri => base_uri.to_s
        }
      }
    end

    def request(method, path, transformer, options = {})
      send(method, path, request_params(transformer, options))
    end

  end
end
