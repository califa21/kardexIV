class PieceChangeesController < ApplicationController
  before_action :set_piece_changee, only: [:show, :edit, :update, :destroy]

  # GET /piece_changees
  # GET /piece_changees.json
  def index
    @piece_changees = PieceChangee.all
  end

  # GET /piece_changees/1
  # GET /piece_changees/1.json
  def show
  end

  # GET /piece_changees/new
  def new
    @piece_changee = PieceChangee.new
  end

  # GET /piece_changees/1/edit
  def edit
  end

  # POST /piece_changees
  # POST /piece_changees.json
  def create
    @piece_changee = PieceChangee.new(piece_changee_params)

    respond_to do |format|
      if @piece_changee.save
        format.html { redirect_to @piece_changee, notice: 'Piece changee was successfully created.' }
        format.json { render action: 'show', status: :created, location: @piece_changee }
      else
        format.html { render action: 'new' }
        format.json { render json: @piece_changee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /piece_changees/1
  # PATCH/PUT /piece_changees/1.json
  def update
    respond_to do |format|
      if @piece_changee.update(piece_changee_params)
        format.html { redirect_to @piece_changee, notice: 'Piece changee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @piece_changee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /piece_changees/1
  # DELETE /piece_changees/1.json
  def destroy
    @piece_changee.destroy
    respond_to do |format|
      format.html { redirect_to piece_changees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_piece_changee
      @piece_changee = PieceChangee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def piece_changee_params
      params[:piece_changee]
    end
end
