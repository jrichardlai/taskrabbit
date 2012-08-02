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
    its(:runners) { should be_a(Taskrabbit::Collection) }
    its(:cost_in_cents) { should == 0 }
    its(:description) { should == '' }
    its(:private_description) { should == '' }
    its(:named_price) { should == nil }
    its(:charge_price) { should == nil }
    its(:cost_in_cents) { should == 0 }
    its(:private_runner) { should == false }
    its(:virtual) { should == false }
    its(:state) { should == 'closed' }
    its(:state_label) { should == 'closed' }
    its(:location_visits) { should be_nil }
    its(:city) { should be_instance_of(Taskrabbit::City) }
    its(:assign_by_time) { should be_instance_of(Time) }
    its(:complete_by_time) { should be_instance_of(Time) }
    its(:state_changed_at) { should be_instance_of(Time) }
    its(:links) { should be_instance_of(Hash) }

    it "allows passing number_runners_to_fill" do
      tr      = Taskrabbit::Api.new(TR_USERS[:without_card][:secret])
      tr_task = tr.tasks.new(valid_params.merge({:number_runners_to_fill => 3}))
      tr_task.number_runners_to_fill.should == 3
    end
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
          Taskrabbit::Api.should_not_receive(:get).with("/api/v1/tasks", anything)
          tr_tasks.last
        end
      end
    end
    
    describe "#new_record?" do
      subject { Taskrabbit::Task.new }

      it "returns true if the task has no id" do
        subject.stub(:id => nil)
        subject.should be_new_record
      end

      it "returns false if the task has an id" do
        subject.stub(:id => 123)
        subject.should_not be_new_record
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

      it "should not do an extra query to tasks if the id is nil" do
        Taskrabbit::Api.should_not_receive(:get).with("http://localhost:3000/api/v1/tasks/?")
        Taskrabbit::Api.should_receive(:post).with("/api/v1/tasks", anything).and_return({:id => 1})
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        tr_task = tr.tasks.new(valid_params)
        tr_task.save
      end

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
    
    describe "#update" do
      context "with valid params" do
        it "should return an error if the user is not logged in" do
          tr = Taskrabbit::Api.new
          VCR.use_cassette('tasks/create/without_user', :record => :new_episodes) do
            tr_task = nil
            expect { tr_task = tr.tasks.create(valid_params) }.to raise_error(Taskrabbit::Error, 'There must be an authenticated user for this action')
            tr_task.should be_nil
          end
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
            tr_task = tr.tasks.new(valid_params)
            tr_task.save.should == false
            tr_task.should be_instance_of(Taskrabbit::Task)
            tr_task.redirect?.should be_true
            tr_task.redirect_url.should =~ %r{https://local\.taskrabbit\.com/tasks/my-first-task--\d+\?card=true}
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
            tr_task = tr.tasks.create(invalid_params)
            tr_task.should be_instance_of(Taskrabbit::Task)
            tr_task.errors.should == {"messages"=>["Task title can't be blank", "Amount you are willing to pay needs to be a whole dollar amount greater than zero"], 
                                      "fields"=>[["name", "can't be blank"], ["named_price", "needs to be a whole dollar amount greater than zero"]]}
            tr_task.error.should  == "Task title can't be blank, \nAmount you are willing to pay needs to be a whole dollar amount greater than zero"
          end
        end
      end
      
      it "should post locations" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('tasks/create/with_location', :record => :new_episodes) do
          tr_task = nil
          params_with_locations = valid_params.merge({:other_locations_attributes => [
            {
              "name" => "Home",
              "address" => "123 Main St",
              "city" => "Boston",
              "state" => "MA",
              "zip" => "02154",
              "lat" => "42.358432",
              "lng" => "-71.059774"
            }, 
            {
              "name" => "Middle of the park",
              "lat" => "42.358430",
              "lng" => "-71.059772"
            }
          ]})
          expect { tr_task = tr.tasks.create(params_with_locations) }.to_not raise_error
          tr_task.should be_instance_of(Taskrabbit::Task)
          tr_task.location_visits.count.should == 2
        end
      end
    end
  end
end