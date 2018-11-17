class NewUserController < ApplicationController

    def new
        @user = User.new
    end



    def create
        @user = Create.new(new_user_params)
    end






private

  def new_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :org_id, :status) 
  end
end
