class BookingDetailsController < ApplicationController

  def create
    if session[:reservation]
      dish = Dish.find_by id: params[:dish_id]
      unless session[:reservation]["detail"]
        session[:reservation][:detail] = {dish.id.to_s => {"dish_name": dish.name, "dish_price": dish.price, "quantity": Settings.dish.default_quantity}}
      else
        session[:reservation]["detail"].merge!({dish.id.to_s => {"dish_name": dish.name, "dish_price": dish.price, "quantity": Settings.dish.default_quantity}})
      end
      redirect_to carts_path
    else
      respond_to do |format|
        format.html{
          flash[:warning] = t "require_booktable"
          redirect_to tables_path
        }
        format.js{
          render action: "require_booktable"
        }
      end
    end
  end
end
