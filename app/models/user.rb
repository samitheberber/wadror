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
  validates_format_of :password, with: /\A.*[^[:alpha:]]+.*\Z/, message: 'must have also non-letters'

  def favorite_beer
    return nil if ratings.empty?
    ratings.order('score DESC').first.beer
  end

  def favorite_style
    return nil if beers.empty?
    average_with_property :style
  end

  def favorite_brewery
    return nil if beers.empty?
    average_with_property :brewery
  end

  private

  def average_with_property property
    lollers = ratings.group_by{|rating| rating.beer.send property}
    average_from_members lollers
  end

  def average_from_members lols
    lol, _ = lols.max_by{|style, rs| rs.inject(0.0) {|sum, rating| sum + rating.score } / rs.size}
    lol
  end
end
