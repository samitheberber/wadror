require 'spec_helper'

describe Brewery do
  it "has the name and year set correctly and is saved to database" do
    brewery = Brewery.create name: "Schlenkerla", year: 1674

    brewery.name.should == "Schlenkerla"
    brewery.year.should == 1674
    brewery.valid?.should == true
  end
end
