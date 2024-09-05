class RegistersController < ApplicationController
  def index
    @register = Register.all
  end
  def new
    @register = Register.new
  end
  def create
    @register = Register.new(register_params)
    if @register.save
      redirect_to root_path
    else
      render "new"
    end
  end
  def register_params
    params.require(:register).permit(:fistName, :lastName, :birthDay, :gender, :email, :phoneNumber, :subJect)
  end
end
