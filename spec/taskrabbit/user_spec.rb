require 'spec_helper'

describe Taskrabbit::User do
  describe "api endpoints" do
    describe "#find" do
      it "should fetch users" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('users/find', :record => :new_episodes) do
          tr_user = nil
          expect { tr_user = tr.users.find(TR_USERS[:without_card][:id]) }.to_not raise_error
          tr_user.id.should == TR_USERS[:without_card][:id]
          tr_user.short_name.should == 'John'
          tr_user.should be_instance_of(Taskrabbit::User)
        end
      end
      
      describe "tasks" do
        it "should fetch tasks with users/#{TR_USERS[:with_card][:id]}/tasks" do
          tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
          VCR.use_cassette('users/tasks/all', :record => :new_episodes) do
            tr_tasks = nil
            expect { tr_tasks = tr.users.find(TR_USERS[:with_card][:id]).tasks.all }.to_not raise_error
            tr_tasks.should be_a(Taskrabbit::Collection)
            tr_tasks.first.should be_instance_of(Taskrabbit::Task)
          end
        end
      end
    end
  end
end