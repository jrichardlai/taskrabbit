require 'spec_helper'

describe Taskrabbit::Collection do
  subject { Taskrabbit::Collection.new }

  Taskrabbit::Collection::ARRAY_METHODS.each do |method|
    it "should define #{method}" do
      subject.should_receive(method)
      expect { subject.send(method) }.to_not raise_error
    end
    
    it "should call the #{method} on items" do
      subject.items.should_receive(method)
      expect { subject.send(method) }.to_not raise_error
    end
  end
end