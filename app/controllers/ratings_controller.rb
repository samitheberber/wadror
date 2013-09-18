class RatingsController < ApplicationController
  before_filter :ensure_that_signed_in, except: [:index]

  def index
    @number_of_ratings = Rating.count
    @top_beers = Beer.top(3)
    @top_styles = Style.top(3)
    @top_breweries = Brewery.top(3)
    @active_users = User.active_raters.take(3)
    @latest_ratings = Rating.recent.limit(5)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new rating_params
    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if currently_signed_in? rating.user
    redirect_to :back
  end

  private
    def rating_params
      params.require(:rating).permit(:score, :beer_id)
    end
end
