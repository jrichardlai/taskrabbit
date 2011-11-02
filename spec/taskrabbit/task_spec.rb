require 'spec_helper'

describe Taskrabbit::Task do
  describe "api endpoints" do
    #tr.tasks wont do the request
    #tr.tasks.first will do the request
    #tr.tasks.all
    #tr.tasks.anything will do the request exect if using find !
    describe "#tasks" do
      it "should fetch tasks" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks/all', :record => :new_episodes) do
          tr_tasks = nil
          expect { tr_tasks = tr.tasks.all }.to_not raise_error
          tr_tasks.should be_a(Taskrabbit::Collection)
          tr_tasks.first.should be_instance_of(Taskrabbit::Task)
        end
      end
    end
    
    describe "#find" do

      it "should fetch tasks" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks/find', :record => :new_episodes) do
          tr_task = nil
          expect { tr_task = tr.tasks.find(22545) }.to_not raise_error
          tr_task.should be_instance_of(Taskrabbit::Task)
        end
      end
      
    end
    
    describe "#create" do
      context "with valid params" do
        let(:valid_params) { 
          {
            "name" => "My First Task", 
            "named_price" => 20, 
            "city_id" => 4
          } 
        }

        it "should return an error if the user is not logged in" do
          tr = Taskrabbit::Api.new
          VCR.use_cassette('tasks/create/without_user', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(valid_params) }.to raise_error(Taskrabbit::Error, 'There must be an authenticated user for this action')
            tr_task.should be_nil
          end
        end

        it "should create the task if the user is authenticated but does not have a credit card" do
          tr = Taskrabbit::Api.new(TR_USERS[:without_card][:secret])
          VCR.use_cassette('tasks/create/without_credit_card', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(valid_params) }.to_not raise_error
            tr_task.should be_instance_of(Taskrabbit::Task)
          end
        end

        it "should create the task if the user is authenticated and has a credit card" do
          tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
          VCR.use_cassette('tasks/create/default', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(valid_params) }.to_not raise_error
            tr_task.should be_instance_of(Taskrabbit::Task)
            # tr_task.unpaid?.should == true
          end
        end
      end
      
      context "with invalid params" do
        let(:invalid_params) { {} }

        it "should create the task if the user is authenticated and has a credit card" do
          tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
          VCR.use_cassette('tasks/create/with_invalid_params', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(invalid_params) }.to
            raise_error(Taskrabbit::Error, "Task title can't be blank,\n" +
                                           "Amount you are willing to pay needs to be a whole dollar amount greater than zero")
            tr_task.should be_nil
          end
        end
      end
    end
  end
end