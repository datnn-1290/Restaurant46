class HomeController < ApplicationController
  def index
    @lastest_dishes = Dish.lastest Settings.home.dish_popular_number
    @popular_dishes = Dish.most_popular_dishes
  end
end
