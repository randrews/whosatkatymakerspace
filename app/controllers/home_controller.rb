class HomeController < ApplicationController
  def index
    @visits = Visit.active
  end
end
