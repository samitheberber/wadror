require 'spec_helper'

describe Beer do

  let(:beer) do
    Beer.new
  end

  before(:each) do
    expect(beer.valid?).to eq(false)
  end

  def required(field)
    expect(beer.errors[field].grep(/blank/).empty?).to eq(false)
  end

  it "must have name" do
    required(:name)
  end

  it "must have style" do
    required(:style)
  end
end
