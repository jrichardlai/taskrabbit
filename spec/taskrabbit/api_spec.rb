require 'spec_helper'

describe Taskrabbit::Api do
  describe "api defaults" do
    it "should have a default client secret to nil" do
      Taskrabbit::Api.client_secret.should == nil
    end

    it "should be able to set the client_secret" do
      Taskrabbit::Api.client_secret = 'asecret'
      Taskrabbit::Api.client_secret.should == 'asecret'
    end
  end

  describe "#new" do
    it "should initialize without params" do
      expect { Taskrabbit::Api.new }.to_not raise_error
    end

    it "should initialize with user_token" do
      expect { 
        tr = Taskrabbit::Api.new("sometoken")
        tr.user_token.should == "sometoken"
      }.to_not raise_error
    end
  end
end
