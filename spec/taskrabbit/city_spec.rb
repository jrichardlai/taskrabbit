require 'spec_helper'

describe Taskrabbit::City do
  describe "api endpoints" do
    describe "#all" do
      it "should fetch all cities" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('cities/all', :record => :new_episodes) do
          cities = nil
          expect { cities = tr.cities.all }.to_not raise_error
          cities.should be_a(Taskrabbit::Collection)
          cities.count.should == 6
          cities.keys.should  == ["items", "links"]
          cities.each do |city|
            city.should be_instance_of Taskrabbit::City
          end
        end
      end
    end

    describe "#find" do
      it "should not fetch if not accessing an existing param" do
        tr = Taskrabbit::Api.new
        city = nil
        expect { city = tr.cities.find(3) }.to_not raise_error
        city.id.should == 3
      end

      it "should should fetch the city" do
        tr = Taskrabbit::Api.new
        VCR.use_cassette('cities/find', :record => :new_episodes) do
          city = nil
          expect { city = tr.cities.find(3) }.to_not raise_error
          city.id.should == 3
          city.name.should == 'SF Bay Area'
        end
      end
    end
  end
end