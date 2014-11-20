class ServicesController < ApplicationController
  def index
    order_param = (params[:order] || :Day).to_sym
    case order_param
    when :Day
      @services = Service.all.to_a
      weekorder = {"Sunday" => 1, "Monday" => 2, "Tuesday" => 3, "Wednesday" => 4, "Thursday" => 5, "Friday" => 6, "Saturday" => 7}
      @services.sort! {|a,b| weekorder[a.day_of_week] <=> weekorder[b.day_of_week]}
 # own sort operation
    when :Time
      @services = Service.order(:start_time)
    end
  end
end

