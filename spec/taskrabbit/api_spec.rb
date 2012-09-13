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

  it "should return an error if the client is not set" do
    secret = Taskrabbit.api_secret
    Taskrabbit.api_secret = nil
    tr = Taskrabbit::Api.new
    VCR.use_cassette('tasks/without_client', :record => :new_episodes) do
      expect { tr.tasks.all }.to raise_error(Taskrabbit::Error, 'Missing valid client application')
    end
    Taskrabbit.api_secret = secret
  end

  it "should return an error if the client is not set" do
    tr = Taskrabbit::Api.new
    VCR.use_cassette('errors/404', :record => :new_episodes) do
      expect { tr.tasks.find('something-that-doesnot-exists').name }.to raise_error(Taskrabbit::Error, 'The requested resource could not be found')
    end
  end
end
