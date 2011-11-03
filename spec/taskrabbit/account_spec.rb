require 'spec_helper'

describe Taskrabbit::Account do
  describe "account properties" do
    before :all do
      tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
      VCR.use_cassette('account/properties', :record => :new_episodes) do
        @user = tr.account
        @user.load
      end
    end

    subject { @user }

    its(:id) { should == TR_USERS[:with_card][:id] }
    its(:short_name) { should == "Bob" }
    its(:first_name) { should == "Bob" }
    its(:full_name) { should == "Bob Sponge" }
    its(:display_name) { should == "Bob S." }
    its(:tasks) { should be_a(Taskrabbit::Collection) }
    its(:city) { should be_instance_of(Taskrabbit::City) }
    its(:zip_code) { should == "64321" }
    its(:locations) { should be_instance_of(Hash) }
    its(:links) { should be_instance_of(Hash) }
  end

  describe "api endpoints" do
    describe ".account" do
      it "should return an error if the user is not passed" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('account/no_user', :record => :new_episodes) do
          tr_account = nil
          expect { tr_account = tr.account }.to_not raise_error
          expect { tr_account = tr_account.short_name }.to raise_error(Taskrabbit::Error, 'There must be an authenticated user for this action')
        end
      end
      
      it "should return the account of the user" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('account/with_user', :record => :new_episodes) do
          tr_account = nil
          expect { tr_account = tr.account }.to_not raise_error
          tr_account.short_name.should == 'Bob'
        end        
      end
    end

    describe ".tasks" do
      it "should fetch the tasks of the user" do
        tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
        VCR.use_cassette('account/tasks', :record => :new_episodes) do
          tr_account = nil
          expect { tr_account = tr.account }.to_not raise_error
          account_tasks = tr_account.tasks.all
          account_tasks.should be_a(Taskrabbit::Collection)
          account_tasks.first.should be_instance_of(Taskrabbit::Task)
        end
      end
    end
  end
end