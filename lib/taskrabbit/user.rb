module Taskrabbit
  class User < APISmith::Smash
    property :id
    property :short_name
    property :full_name

    class << self
      def find(api, id)
        # if @found
          # find from users tasks if loaded 
          # @found.detect { |document| document.id == id }
        # else
          api.request('get', "users/#{id.to_s}", self)
        # end
      end

      def account(api)
      end
    end
  end
end
