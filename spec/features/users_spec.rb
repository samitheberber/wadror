require 'spec_helper'

describe "User" do
  include OwnTestHelper

  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in 'Pekka', 'foobar1'

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to sign in form if wrong credentials given" do
      sign_in 'Pekka', 'wrong'

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'secret55')
    fill_in('user_password_confirmation', with: 'secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "favorite stuff" do
    it "is blank, when user hasn't any" do
      visit user_path(@user)
      expect(page).to have_content "has not favorite style"
      expect(page).to have_content "has not favorite brewery"
    end

    it "is shown, when user has any" do
      beer = FactoryGirl.create :beer
      @user.ratings << FactoryGirl.create(:rating, beer: beer)
      visit user_path(@user)

      expect(page).to have_content "has #{beer.style} as favorite style"
      expect(page).to have_content "has #{beer.brewery.name} as favorite brewery"
    end
  end
end
