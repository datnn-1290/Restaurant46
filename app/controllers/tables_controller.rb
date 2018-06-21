class TablesController < ApplicationController
  before_action :broadcast, only: :index

  def index
    @q = Table.ransack(params[:q])
    @tables = @q.result.page(params[:page]).per(Settings.paginate.table_perpage) if @q.result
  end

  def show
    @booking = Booking.new
    @table = Table.find_by id: params[:id]
    return if @table
    flash[:danger] = t ".cant_find"
    redirect_to root_url
  end

  private

  def broadcast
    ActionCable.server.broadcast "web_notifications", title: 'New things!', body: 'All the news fit to print'
  end
end
