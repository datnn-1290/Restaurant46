class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
