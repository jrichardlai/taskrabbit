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
    it "should be able to set the api_secret" do
      Taskrabbit.api_secret = 'asecret'
      Taskrabbit.api_secret.should == 'asecret'
    end
  end
end
