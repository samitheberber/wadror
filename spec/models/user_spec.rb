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
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer)
      beer3 = FactoryGirl.create(:beer)
      rating1 = FactoryGirl.create(:rating, beer: beer1, user: user)
      rating2 = FactoryGirl.create(:rating, score: 25,  beer: beer2, user: user)
      rating3 = FactoryGirl.create(:rating, score: 9, beer: beer3, user: user)

      expect(user.favorite_beer).to eq(beer2)
    end
  end
end
