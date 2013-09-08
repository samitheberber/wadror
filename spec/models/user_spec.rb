require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username: "Pekka"
    expect(user.username).to eq("Pekka")
  end

  describe "without valid password" do
    let(:user) do
      User.new username: "Pekka", password: "asd"
    end

    before(:each) do
      expect(user.valid?).to be(false)
    end

    def password_has_error(regex)
      not user.errors[:password].grep(regex).empty?
    end

    it "should fail, when password is too short" do
      expect(password_has_error(/is too short/)).to eq(true)
    end

    it "should fail, when only letters" do
      expect(password_has_error(/non-letters/)).to eq(true)
    end
  end

  it "is not saved without a proper password" do
    user = User.create username: "Pekka"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) do
      FactoryGirl.create(:user)
    end

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating1)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) do
      FactoryGirl.create(:user)
    end

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating 10, user
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings 10, 20, 15, 7, 9, user
      best = create_beer_with_rating 25, user
      expect(user.favorite_beer).to eq(best)
    end

    def create_beers_with_ratings(*scores, user)
      scores.each do |score|
        create_beer_with_rating score, user
      end
    end

    def create_beer_with_rating(score, user)
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, score: score,  beer: beer, user: user)
      beer
    end
  end

  describe "favorite style" do
    let(:user) do
      FactoryGirl.create(:user)
    end

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      style = "foobar"
      create_beer_with_rating_and_style 10, style, user
      expect(user.favorite_style).to eq(style)
    end

    it "is the one with averate rating if several rated" do
      fav_style = "foobar"
      create_beers_with_ratings_and_style 10, 20, 15, 7, 9, "lol", user
      create_beers_with_ratings_and_style 10, 20, 15, 10, 20, "zomg", user
      create_beers_with_ratings_and_style 30, 20, 15, 45, 10, fav_style, user
      expect(user.favorite_style).to eq(fav_style)
    end

    def create_beers_with_ratings_and_style(*scores, style, user)
      scores.each do |score|
        create_beer_with_rating_and_style score, style, user
      end
    end

    def create_beer_with_rating_and_style(score, style, user)
      beer = FactoryGirl.create(:beer, style: style)
      FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    end
  end

  describe "favorite brewery" do
    let(:user) do
      FactoryGirl.create(:user)
    end

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      brewery = FactoryGirl.create(:brewery)
      create_beer_with_rating_and_brewery 10, brewery, user
      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with averate rating if several rated" do
      brewery = FactoryGirl.create(:brewery)
      create_beers_with_ratings_and_brewery 10, 20, 15, 7, 9, FactoryGirl.create(:brewery), user
      create_beers_with_ratings_and_brewery 10, 20, 15, 10, 20, FactoryGirl.create(:brewery), user
      create_beers_with_ratings_and_brewery 30, 20, 15, 45, 10, brewery, user
      expect(user.favorite_brewery).to eq(brewery)
    end

    def create_beers_with_ratings_and_brewery(*scores, brewery, user)
      scores.each do |score|
        create_beer_with_rating_and_brewery score, brewery, user
      end
    end

    def create_beer_with_rating_and_brewery(score, brewery, user)
      beer = FactoryGirl.create(:beer, brewery: brewery)
      FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    end
  end
end
