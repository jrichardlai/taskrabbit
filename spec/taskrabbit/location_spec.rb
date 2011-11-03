require 'spec_helper'

describe Taskrabbit::Location do

  describe "location properties" do

    before :all do
      tr = Taskrabbit::Api.new(TR_USERS[:with_card][:secret])
      VCR.use_cassette('locations/properties', :record => :new_episodes) do
        @location = tr.account.locations.first
      end
    end

    subject { @location }

    its(:id                ) { should == 37439 }
    its(:name              ) { should == "Home" }
    its(:address           ) { should == "432 example" }
    its(:approximate_radius) { should == 0 }
    its(:city              ) { should == "San Francisco" }
    its(:zip               ) { should == "94123" }
    its(:partial           ) { should == "example, San Francisco, Ca 94123" }
    its(:state             ) { should == "Ca" }
    its(:complete          ) { should == "432 example, San Francisco, Ca 94123" }
  end
end