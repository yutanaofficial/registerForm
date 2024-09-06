class RegistersController < ApplicationController
  before_action :set_register, only: [ :edit, :update, :destroy ]

  def index
    @registers = Register.all
  end

  def new
    @register = Register.new
  end

  def create
    @register = Register.new(register_params)
    if @register.save
      redirect_to registers_path, notice: "Registration successful!"
    else
      render :new
    end
  end

  def edit
    # Uses the @register from before_action :set_register
  end

  def update
    if @register.update(register_params)
      redirect_to registers_path, notice: "Record updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @register.destroy
    redirect_to registers_path, notice: "Record deleted successfully!"
  end

  private

  def set_register
    @register = Register.find(params[:id])
  end

  def register_params
    params.require(:register).permit(:fistName, :lastName, :birthDay, :gender, :email, :phoneNumber, :subJect)
  end
end
