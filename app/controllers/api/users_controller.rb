module Api
  class UsersController < ApplicationController

    before_filter :authenticate_user_from_token!

    respond_to :json

    def index
      respond_with User.all
    end

    def show
      respond_with User.where(username: params[:login]).first
    end
  end  
end