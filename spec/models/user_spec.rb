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
end
