class SchoolBreaksController < ApplicationController
  before_action :set_school_break, only: %i[ show edit update destroy ]

  # GET /school_breaks or /school_breaks.json
  def index
    @school_breaks = SchoolBreak.all
  end

  # GET /school_breaks/1 or /school_breaks/1.json
  def show
  end

  # GET /school_breaks/new
  def new
    @school_break = SchoolBreak.new
  end

  # GET /school_breaks/1/edit
  def edit
  end

  # POST /school_breaks or /school_breaks.json
  def create
    @school_break = SchoolBreak.new(school_break_params)

    respond_to do |format|
      if @school_break.save
        format.html { redirect_to school_break_url(@school_break), notice: "School break was successfully created." }
        format.turbo_stream
        format.json { render :show, status: :created, location: @school_break }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_break.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_breaks/1 or /school_breaks/1.json
  def update
    respond_to do |format|
      if @school_break.update(school_break_params)
        format.html { redirect_to school_break_url(@school_break), notice: "School break was successfully updated." }
        format.turbo_stream
        format.json { render :show, status: :ok, location: @school_break }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_break.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_breaks/1 or /school_breaks/1.json
  def destroy
    @school_break.destroy

    respond_to do |format|
      format.html { redirect_to school_breaks_url, notice: "School break was successfully destroyed." }
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school_break
      @school_break = SchoolBreak.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_break_params
      params.require(:school_break).permit(:name, :start_date, :end_date)
    end
end
