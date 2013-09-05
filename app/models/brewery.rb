class Brewery < ActiveRecord::Base
  has_many :beers
  has_many :ratings, :through => :beers

  def average_rating
    ratings.average(:score)
  end
end
