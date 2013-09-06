class Brewery < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name
  validate :year_to_be_sane

  has_many :beers
  has_many :ratings, :through => :beers

  def year_to_be_sane
    unless (1042..Date.today.year).include? year
      errors.add(:year, "must be past 1042 and not past this year")
    end
  end
end
