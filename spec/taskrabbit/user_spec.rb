require 'spec_helper'

describe Taskrabbit::User do
  describe "api endpoints" do
    describe "#find" do
      it "should fetch users" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('users/find', :record => :new_episodes) do
          tr_user = nil
          expect { tr_user = tr.users.find(49719) }.to_not raise_error
          tr_user.should be_instance_of(Taskrabbit::User)
        end
      end
    end
  end
end