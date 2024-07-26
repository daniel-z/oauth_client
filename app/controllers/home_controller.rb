class HomeController < ApplicationController

  def index
    if session[:access_token].present?
      render
    else
      redirect_to signin_path
    end
  end

  private
end
