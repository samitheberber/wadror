module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.average(:score)
  end

  module ClassMethods
    def top n
      self.all.sort_by{|b| -(b.average_rating or 0)}.take n
    end
  end
end
