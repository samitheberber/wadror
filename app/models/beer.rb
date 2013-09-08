class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name
  validates_presence_of :style

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{name}, #{brewery.name}"
  end
end
