require 'spec_helper'

describe Taskrabbit do
  after do
    Taskrabbit.reset
  end

  describe ".options" do
    it "should returns the options" do
      Taskrabbit.options
    end
  end

  describe ".configure" do
    Taskrabbit::Config::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Taskrabbit.configure do |config|
          config.send("#{key}=", key)
          Taskrabbit.send(key).should == key
        end
      end
    end
  end
  
  describe "api defaults" do
    it "should have a default client secret to nil" do
      Taskrabbit.client_secret.should == nil
    end

    it "should be able to set the client_secret" do
      Taskrabbit.client_secret = 'asecret'
      Taskrabbit.client_secret.should == 'asecret'
    end
  end
end
