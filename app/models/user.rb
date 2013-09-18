class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships
  has_many :beer_clubs, through: :memberships

  has_many :member_ins, conditions: {confirmed: true}, class_name: 'Membership'
  has_many :membered_beer_clubs, through: :member_ins, source: :beer_club

  has_many :applications, conditions: {confirmed: [nil, false]}, class_name: 'Membership'
  has_many :applied_beer_clubs, through: :applications, source: :beer_club

  validates_uniqueness_of :username
  validates_length_of :username, in: 3..15
  validates_length_of :password, minimum: 4
  validates_format_of :password, with: /\A.*[^[:alpha:]]+.*\Z/, message: 'must have also non-letters'


  def self.active_raters
    all.sort_by{|user| -user.ratings.count}
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order('score DESC').first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  private

  def favorite property
    return nil if beers.empty?
    ratings_with_property = ratings.group_by{|rating| rating.beer.send property}
    ratings_with_property.max_by{|_, rs| rs.map(&:score).inject(0.0, :+) / rs.size}.first
  end
end
