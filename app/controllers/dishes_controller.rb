class DishesController < ApplicationController
  before_action :load_categories, only: %i(index show)

  def index
    if params[:q]
      @dishes = Dish.search_elastic(params[:q]).results
      @dishes_search = Dish.search_elastic(params[:q]).results
    else
      @dishes_search = Dish.search_all.results
    end
  end

  def show
    @dish = Dish.with_images.find_by id: params[:id]
    unless @dish
      flash[:danger] = t ".cant_find"
      redirect_to root_url
    end
  end

  def load_categories
    @categories = Category.ordered_by_name
  end
end
