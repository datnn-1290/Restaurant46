class DishesController < ApplicationController
  before_action :load_categories, only: %i(show)

  def index
    @dishes = Dish.ransack(name_cont: params[:q]).result(distinct: true).limit(Settings.limit.autocomplete)
    @dishes_search = Dish.search_elastic(params[:q]).results
  end

  def show
    @dish = Dish.find_by id: params[:id]
    unless @dish
      flash[:danger] = t ".cant_find"
      redirect_to root_url
    end
  end

  private

  def load_categories
    @categories = Category.ordered_by_name
  end
end
