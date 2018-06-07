class BookingsController < ApplicationController
  before_action :check_user, only: :index
  before_action :check_cart, only: :index

  def index
    @booking = current_user.bookings.build
    current_cart["detail"].each do |key, value|
      @booking.booking_details.build(quantity: value["quantity"], price: value["dish_price"], dish_id: key)
    end
  end

  def create
    @booking = current_user.bookings.build booking_params
    @booking.status = Booking.statuses[:pending]
    if @booking.save
      session.delete :reservation
      flash[:success] = t "order_success"
      redirect_to reservations_path
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:time_start, :price_table, :table_id, booking_details_attributes: [:id, :quantity, :price, :booking_id, :dish_id])
  end

  def check_user
    unless user_signed_in?
      flash[:info] = t "require_login"
      redirect_to new_user_session_path
    end
  end

  def check_cart
    if session[:reservation].nil?
      flash[:info] = t "require_booktable"
      redirect_to tables_path
    elsif session[:reservation]["detail"].nil?
      flash[:info] = t "reserved_table"
      redirect_to root_path
    end
  end
end
