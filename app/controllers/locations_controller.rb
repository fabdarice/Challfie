class LocationsController < ApplicationController
    before_filter :authenticate_user!

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(locations_params)

    if @location.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy    
    @location = Location.find(params[:id])
    if (@location.destroy)
      flash[:notice] = 'Category deleted.'
    end
    redirect_to root_path
  end


  private

    def locations_params
      params.require(:location).permit(:name, :address, :latitude, :longitude)
    end

end
