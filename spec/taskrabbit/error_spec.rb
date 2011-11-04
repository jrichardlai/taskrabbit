require 'spec_helper'

describe Taskrabbit::Error do
  it "saves the error message" do
    e = Taskrabbit::Error.new('something')
    e.message.should == 'something'
  end
  
  it "saves the response" do
    e = Taskrabbit::Error.new('something', {:errors => ['test']})
    e.response.should == {:errors => ['test']}
  end
end