class HomeController < ApplicationController
  def index
    @locations = Location.all
  end
end
