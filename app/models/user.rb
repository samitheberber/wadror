class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships
  has_many :beer_clubs, through: :memberships

  validates_uniqueness_of :username
  validates_length_of :username, in: 3..15
  validates_length_of :password, minimum: 4
end
