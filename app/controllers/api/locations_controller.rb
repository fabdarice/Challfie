module Api
  class LocationsController < ApplicationController

    before_filter :authenticate_user_from_token!
    skip_before_filter  :verify_authenticity_token, :only => [:create]

    respond_to :json

    def index
      respond_with Location.all
    end

    def show
      respond_with User.find(params[:id])
    end

    def create
      # respond_with User.create(access_token: params[:access_token], city: params[:city], created_at: Time.now, phone: params[:phone], region: params[:region], updated_at: Time.now)
      @location = Location.create(name: params[:name], address: params[:address], latitude: params[:latitude], longitude: params[:longitude])      
      respond_to do |format|
        if @location.save
          format.json {render json: @location}
        else
          format.json {render json: {:error_message => @location.error, :status => 402}}
        end
      end
    end

    def update
#                  respond_with User.update(params[:id], params[:users])

    end

    def destroy
      #            respond_with User.destroy(params[:id])

    end

end