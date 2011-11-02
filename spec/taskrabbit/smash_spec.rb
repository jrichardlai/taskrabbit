require 'spec_helper'

describe Taskrabbit::Smash do
  
  module Taskrabbit
    class Something < Smash
    end
  end

  describe ".find" do
    it "should raise error if there is no id passed" do
      expect { 
        Taskrabbit::Something.find(Taskrabbit::Api.new, nil) 
      }.to raise_error(Taskrabbit::Error, "Couldn't find Taskrabbit::Something without an ID")
    end
  end
end