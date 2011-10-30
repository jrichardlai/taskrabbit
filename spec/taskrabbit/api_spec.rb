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
  
  describe "api endpoints" do
    #tr.tasks wont do the request
    #tr.tasks.first will do the request
    #tr.tasks.all
    #tr.tasks.anything will do the request exect if using find !
    describe "#tasks" do
      before do
        @secret = Taskrabbit.client_secret
      end

      after do
        Taskrabbit.client_secret = @secret
      end

      it "should return an error if the client is not set" do
        Taskrabbit.client_secret = nil
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks_without_client', :record => :new_episodes) do
          expect { tr.tasks.all }.to raise_error(Taskrabbit::Error, 'Missing valid client application')
        end
      end

      it "should fetch tasks" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks', :record => :new_episodes) do
          tr_tasks = nil
          expect { tr_tasks = tr.tasks.all }.to_not raise_error
          tr_tasks.first.should be_instance_of(Taskrabbit::Task)
        end
      end
    end
    
    describe "#find" do

      it "should fetch tasks" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('find_task', :record => :new_episodes) do
          tr_task = nil
          expect { tr_task = tr.tasks.find(22545) }.to_not raise_error
          tr_task.should be_instance_of(Taskrabbit::Task)
        end
      end
      
    end
  end
end
