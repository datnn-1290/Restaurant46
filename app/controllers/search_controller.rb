class SearchController < ApplicationController
  def index; end

  def search
    @dishes = Dish.ransack(name_cont: params[:q]).result(distinct: true).limit(Settings.limit.autocomplete)
  end
end
