require 'spec_helper'

describe Beer do

  let!(:beer) do
    Beer.new
  end

  it "must have name" do
    expect(beer.valid?).to eq(false)
    expect(beer.errors[:name].grep(/blank/).empty?).to eq(false)
  end
end
