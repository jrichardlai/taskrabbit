require 'spec_helper'

describe Taskrabbit::Api do

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
