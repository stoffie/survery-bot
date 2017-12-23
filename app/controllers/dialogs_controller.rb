class DialogsController < ApplicationController
  before_action :set_dialog, only: [:show, :edit, :update, :destroy]

  # GET /dialogs
  def index
    @dialogs = Dialog.all
  end

  # GET /dialogs/1
  def show
  end

  # GET /dialogs/new
  def new
    @dialog = Dialog.new
  end

  # GET /dialogs/1/edit
  def edit
  end

  # POST /dialogs
  def create
    @dialog = Dialog.new(dialog_params)

    if @dialog.save
      redirect_to @dialog, notice: 'Dialog was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /dialogs/1
  def update
    if @dialog.update(dialog_params)
      redirect_to @dialog, notice: 'Dialog was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dialogs/1
  def destroy
    @dialog.destroy
    redirect_to dialogs_url, notice: 'Dialog was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dialog
      @dialog = Dialog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dialog_params
      params.require(:dialog).permit(:patient_id, :user_message, :patient_reply)
    end
end
