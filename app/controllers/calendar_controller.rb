class CalendarController < ApplicationController
  # GET /calendar or /calendar.json
  def index
  end

  # GET /calendar/1 or /calendar/1/2022/4
  def show
    year = year_param
    @is_selected_month = params.has_key?(:month)
    month = @is_selected_month ? params[:month].to_i : Date.current.month
    @shift = Shift.new params[:id], year: year, month: month
    if @shift.nil?
      not_found
    end
    month_date = Date.new(year, month, 1)
    @previous_month = month_date.prev_month
    @next_month = month_date.next_month

    today = Date.current
    last_month = 1.month.ago
    if today.year == year && today.month == month || last_month.year == year && last_month.month == month
      @current_shift, @current_shift_date = @shift.current_working_shift
    end

    @public_events = PublicEvent.all_in_month year, month
  rescue Shift::ModelUnknown
    not_found
  end

  # GET /calendar/1/2023
  def year
    @year = year_param
    begin
      Shift.new(params[:id], year: @year, month: 1)
    rescue
      not_found
      return
    end

    @months = []
    12.times do |index|
      shift = Shift.new params[:id], year: @year, month: index + 1
      @months << shift
    end

    if Date.current.year == @year
      @current_shift, @current_shift_date = @months[0].current_working_shift
    end

    @public_events = PublicEvent.all_in_year @year
  end

  private

    def year_param
      return params[:year].to_i if params.has_key? :year
      Date.current.year
    end
end
