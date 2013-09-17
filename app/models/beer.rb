class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  belongs_to :style

  def to_s
    "#{name}, #{brewery.name}"
  end
end
