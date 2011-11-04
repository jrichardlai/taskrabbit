require 'spec_helper'

describe Taskrabbit::Task do
  
  describe "task properties" do

    before :all do
      tr = Taskrabbit::Api.new
      VCR.use_cassette('tasks/properties', :record => :new_episodes) do
        @tr_task = tr.tasks.find(22545)
        @tr_task.fetch
      end
    end

    subject { @tr_task }

    its(:id) { should == 22545 }
    its(:name) { should == "2 Hours of House Cleaning + 1 Hour of House Chores" }
    its(:user) { should be_instance_of(Taskrabbit::User) }
    its(:runner) { should be_instance_of(Taskrabbit::User) }
    its(:cost_in_cents) { should == 0 }
    its(:state) { should == 'closed' }
    its(:state_label) { should == 'closed' }
    its(:city) { should be_instance_of(Taskrabbit::City) }
    its(:assign_by_time) { should be_instance_of(Time) }
    its(:complete_by_time) { should be_instance_of(Time) }
    its(:state_changed_at) { should be_instance_of(Time) }
  end

  let(:valid_params) { 
    {
      "name" => "My First Task", 
      "named_price" => 20, 
      "city_id" => 4
    } 
  }
  
  describe "api endpoints" do
    describe "#tasks" do
      it "should fetch tasks only once" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks/all', :record => :new_episodes) do
          tr_tasks = nil
          expect { tr_tasks = tr.tasks }.to_not raise_error
          tr_tasks.first.should be_instance_of(Taskrabbit::Task)
          Taskrabbit::Api.should_not_receive(:get).with("/api/v1/tasks", anything).never
          tr_tasks.last.should be_instance_of(Taskrabbit::Task)
        end
      end

      it "should refetch tasks if passed :reload => true" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks/all', :record => :new_episodes) do
          tr_tasks = nil
          expect { tr_tasks = tr.tasks }.to_not raise_error
          tr_tasks.first.should be_instance_of(Taskrabbit::Task)
          Taskrabbit::Api.should_receive(:get).with("/api/v1/tasks", anything).once.and_return []
          tr_tasks.last(:reload => true)
        end
      end
    end
    
    describe "#find" do

      it "should fetch tasks" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('tasks/find', :record => :new_episodes) do
          tr_task = nil
          expect { 
            tr_task = tr.tasks.find(22545)
            tr_task.name
          }.to_not raise_error
          tr_task.should be_instance_of(Taskrabbit::Task)
        end
      end
      
    end
    
    describe "#delete!" do
      it "should request DELETE /tasks/#id" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('tasks/delete', :record => :new_episodes) do
          tr_task = nil
          tr_task = tr.tasks.create(valid_params)
          tr_task.should be_instance_of(Taskrabbit::Task)
          expect { tr_task.delete! }.to_not raise_error
          tr_task.should be_instance_of(Taskrabbit::Task)
          tr_task.state.should == 'canceled'
        end
      end
    end
    
    describe "#save" do
      it "should create a new task if new" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('tasks/save', :record => :new_episodes) do
          tr_task = nil
          tr_task = tr.tasks.new(valid_params)
          tr_task.should be_instance_of(Taskrabbit::Task)
          tr_task.save.should == true
          tr_task.id.should_not be_nil
          tr_task.state.should == 'opened'
          tr.tasks.find(tr_task.id).name.should == tr_task.name
        end
      end

      it "should update the task if existing" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('tasks/update', :record => :new_episodes) do
          tr_task = tr.tasks.find(tr.tasks.create(valid_params).id)
          tr_task.name = "New Name"
          tr_task.save.should == true
          tr_task.name.should == "New Name"
        end
      end
    end

    
    describe "#create" do
      context "with valid params" do
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
            # tr_task.unpaid?.should == true
          end
        end

        it "should create the task if the user is authenticated and has a credit card" do
          tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
          VCR.use_cassette('tasks/create/default', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(valid_params) }.to_not raise_error
            tr_task.should be_instance_of(Taskrabbit::Task)
          end
        end

        it "should create the task using the account" do
          tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
          VCR.use_cassette('tasks/create/using_account', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.account.tasks.create(valid_params) }.to_not raise_error
            tr_task.should be_instance_of(Taskrabbit::Task)
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