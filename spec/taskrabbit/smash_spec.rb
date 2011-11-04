require 'spec_helper'

describe Taskrabbit::Smash do

  let(:api) { mock }
  subject { Taskrabbit::Something.new({:name => 'Something'}, api) }
  
  module Taskrabbit
    class Something < Smash
      property :name
    end
  end

  describe ".find" do
    it "should raise error if there is no id passed" do
      expect { 
        Taskrabbit::Something.find(Taskrabbit::Api.new, nil) 
      }.to raise_error(Taskrabbit::Error, "Couldn't find Taskrabbit::Something without an ID")
    end
  end

  it "should be not loaded by default" do
    subject.loaded.should be_false
  end
  
  describe "#valid?" do
    it "should return true" do
      subject.should be_valid
    end
    
    it "should return false if errors is filled" do
      subject.errors = ["something"]
      subject.should_not be_valid
    end
    
    it "should return false if error is filled" do
      subject.error = "something"
      subject.should_not be_valid
    end
  end
  
  describe "#reload" do
    
    context "the request is valid" do
      before do
        api.stub(:request => {"name" => 'Test', "other" => 'Other Test'})
      end
      
      it "should return true" do
        subject.reload(anything, anything).should be_true
      end

      it "should merge the object with the response" do
        subject.reload(anything, anything)
        subject.should == {"name" => 'Test', "other" => 'Other Test'}
      end

      it "should set loaded to true" do
        subject.reload(anything, anything)
        subject.loaded.should be_true
      end
    end

    context "there is an error" do
      before do
        api.stub(:request).and_raise(Taskrabbit::Error.new("Something happened", {:something => "something"}))
      end
      
      it "should raise an exception" do
        expect { subject.reload(anything, anything) }.to raise_error(Taskrabbit::Error, 'Something happened')
      end
      
    end

    context "there is errors in attributes" do
      let(:response) { 
        {
          "errors" => {
            "messages" => ["Task title can't be blank", "Amount you are willing to pay is not a number"],
            "fields" => [["name","can't be blank"], ["named_price","is not a number"]]
            },
            "error" => "Task title can't be blank, \nAmount you are willing to pay is not a number"
          }
      }
      
      before do
        api.stub(:request).and_raise(Taskrabbit::Smash::Error.new("Error Message", response))
      end
      
      it "should catch taskrabbit errors and return false" do
        subject.reload(anything, anything)
        subject.should == {"name" => 'Something'}.merge(response)
      end
      
      it "should return false" do
        subject.reload(anything, anything).should be_false
      end
    end

    it "should empty errors if request does not raise exception" do
      subject.error = "something"
      api.stub(:request => {:name => 'Test', :other => 'Other Test'})
      subject.reload(anything, anything).should be_true
      subject.error.should be_nil
    end
  end
end