require 'spec_helper'

describe Taskrabbit::Proxy do
  
  class Collection
  end
  
  subject { Taskrabbit::Proxy.new(anything, Collection) }
  
  Taskrabbit::Proxy::COLLECTION_DELEGATE.each do |method|
    it "should define #{method}" do
      subject.should_receive(method)
      expect { subject.send(method) }.to_not raise_error
    end
    
    it "should call the #{method} after fetching the collection" do
      the_mock = mock
      the_mock.should_receive(method)
      Collection.should_receive(:all).and_return the_mock
      expect { subject.send(method) }.to_not raise_error
    end
  end
end