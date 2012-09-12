require 'spec_helper'

describe Taskrabbit::Location do

  describe "offers properties" do

    before :all do
      tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
      VCR.use_cassette('tasks/properties', :record => :new_episodes) do
        @tr_task = tr.tasks.find(22545)
        @tr_task.fetch
      end
      VCR.use_cassette('offers/properties', :record => :new_episodes) do
        @offer = @tr_task.offers.first
      end
    end

    subject { @offer }

    its(:id                ) { should == 37439 }
    its(:charge_price      ) { should == "Home" }
    its(:state             ) { should == "432 example" }
  end
end