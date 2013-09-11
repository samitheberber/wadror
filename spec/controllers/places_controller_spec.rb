require 'spec_helper'

describe PlacesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST 'search'" do
    it "returns http success" do
      post 'search', city: 'Helsinki'
      response.should be_success
    end
  end

end
