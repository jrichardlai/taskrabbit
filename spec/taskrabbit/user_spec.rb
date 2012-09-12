require 'spec_helper'

describe Taskrabbit::User do

  describe "user properties" do

    before :all do
      tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
      VCR.use_cassette('users/properties', :record => :new_episodes) do
        @user = tr.users.find(TR_USERS[:with_card][:id])
        @user.fetch
      end
    end

    subject { @user }

    its(:id) { should == TR_USERS[:with_card][:id] }
    its(:short_name) { should == "UserWith" }
    its(:first_name) { should == "UserWith" }
    its(:full_name) { should == "UserWith card" }
    its(:display_name) { should == "UserWith c." }
    its(:runner) { should == false }
    its(:email) { should == 'userwithcard@taskrabbit.com' }
    its(:mobile_phone) { should == nil }
    its(:home_phone) { should == nil }
    its(:tasks) { should == Taskrabbit::Task }
    its(:city) { should be_instance_of(Taskrabbit::City) }
    its(:zip_code) { should == "12345" }
    its(:locations) { should == Taskrabbit::Location }
    its(:links) { should be_instance_of(Hash) }
  end

  describe "api endpoints" do
    describe "#find" do
      it "should fetch users" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('users/find', :record => :new_episodes) do
          tr_user = nil
          expect { tr_user = tr.users.find(TR_USERS[:without_card][:id]) }.to_not raise_error
          tr_user.id.should == TR_USERS[:without_card][:id]
          tr_user.short_name.should == 'User with no'
          tr_user.should be_instance_of(Taskrabbit::User)
        end
      end
      
      describe "tasks" do
        let(:tr) { tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret]) }
        
        it "should not do an extra query to users/#{TR_USERS[:with_card][:id]} when fetching all tasks" do
          Taskrabbit::Api.should_not_receive(:get).with("/api/v1/users/#{TR_USERS[:with_card][:id]}", anything).never
          tr.users.find(TR_USERS[:with_card][:id]).tasks.all
        end

        it "should not do an extra query to users/#{TR_USERS[:with_card][:id]} when finding task" do
          Taskrabbit::Api.should_not_receive(:get).with("/api/v1/users/#{TR_USERS[:with_card][:id]}", anything).never
          tr.users.find(TR_USERS[:with_card][:id]).tasks.find('some-id')
        end

        it "should fetch tasks with users/#{TR_USERS[:with_card][:id]}/tasks" do
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