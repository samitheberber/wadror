class BeersController < ApplicationController
  before_filter :ensure_that_signed_in, except: [:index, :show, :list]

  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_breweries, only: [:new, :edit, :create, :update]
  before_action :set_styles, only: [:new, :edit, :create, :update]

  def index
    @order = params[:order] || 'name'
    @beers = Beer.all(include: [:brewery, :style]).sort_by{ |b| b.send(@order).to_s }
  end

  def list
  end

  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  def edit
  end

  def create
    @beer = Beer.new(beer_params)

    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }

    respond_to do |format|
      if @beer.save
        format.html { redirect_to @beer, notice: 'Beer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer }
      else
        format.html { render action: 'new' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }

    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @beer.destroy if current_user.admin

    ["beers-name", "beers-brewery", "beers-style"].each{ |f| expire_fragment(f) }

    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    def set_breweries
      @breweries = Brewery.all
    end

    def set_styles
      @styles = Style.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :style, :brewery_id)
    end
end
