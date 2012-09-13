require 'spec_helper'

describe Taskrabbit::Location do

  describe "offers properties" do

    before :all do
      tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
      VCR.use_cassette('tasks/with_offers_properties', :record => :new_episodes) do
        @tr_task = tr.tasks.find(ENV["TASK_ID"])
        @tr_task.fetch
      end
      @offer = @tr_task.offers.first
    end

    subject { @offer }

    its(:id                ) { should == 7 }
    its(:charge_price      ) { should == 26 }
    its(:state             ) { should == "sent" }
    its(:runner            ) { should be_instance_of(Taskrabbit::User) }
  end
end