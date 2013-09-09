require 'spec_helper'

describe "Rating" do
  include OwnTestHelper

  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select(beer1.to_s, from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "with beer page" do
    it "shows no rating, when no ratings" do
      visit beer_path(beer1)
      expect(page).to have_content "beer has not yet been rated!"
    end

    it "shows rating, when has rating" do
      beer1.ratings << FactoryGirl.create(:rating)
      visit beer_path(beer1)
      expect(page).to have_content "beer has 1 rating"
    end

    it "shows rating, when has ratings" do
      3.times do
        beer1.ratings << FactoryGirl.create(:rating)
      end
      visit beer_path(beer1)
      expect(page).to have_content "beer has 3 ratings"
    end
  end

  describe "with user page" do
    it "shows no rating, when no ratings" do
      visit user_path(user)
      expect(page).to have_content "#{user.username} has not yet given any ratings!"
    end

    it "shows rating, when has rating" do
      user.ratings << FactoryGirl.create(:rating, beer: beer1)
      visit user_path(user)
      expect(page).to have_content "#{user.username} has given 1 rating"
    end

    it "shows rating, when has ratings" do
      user.ratings << FactoryGirl.create(:rating, beer: beer1)
      user.ratings << FactoryGirl.create(:rating, beer: beer2)
      visit user_path(user)
      expect(page).to have_content "#{user.username} has given 2 ratings"
    end
  end
end
