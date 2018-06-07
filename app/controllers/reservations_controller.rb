class ReservationsController < ApplicationController
  before_action :check_user, only: :index

  def index
    @bookings = current_user.bookings
  end

  def create
    unless session[:reservation].present?
      session[:reservation] = {}
      date_start = params[:reservations][:date_start]
      hour = params[:reservations]["time_start(4i)"]
      minute = params[:reservations]["time_start(5i)"]
      time_start = date_start + " " + hour + ":" + minute
      session[:reservation].merge!({"table"=>{"table_id"=>params[:reservations][:table_id], "price"=>params[:reservations][:table_price],"time_start"=>time_start}})
      flash[:success] = t "reserved_table"
      redirect_to root_path
    else
      flash[:success] = t "reserved_table_again"
    end
  end

  private

  def check_user
    unless user_signed_in?
      flash[:info] = t "require_login"
      redirect_to new_user_session_path
    end
  end
end
