require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    expect(BeermappingAPI).to receive(:places_in).with("kumpula").and_return( [  Place.new(name: "Oljenkorsi") ] )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if none is returned by the API, specific message is shown" do
    expect(BeermappingAPI).to receive(:places_in).with("kumpula").and_return([])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "No locations in kumpula"
  end

  it "if multiple is returned by the API, all are shown" do
    expect(BeermappingAPI).to receive(:places_in).with("kumpula").and_return([Place.new(name: "foo"), Place.new(name: "bar")])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "foo"
    expect(page).to have_content "bar"
  end
end
