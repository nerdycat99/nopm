class UmakesController < ApplicationController
  
  def new
    @user = User.new
  end



  def create
      # @user = Create.new(nu_params)
      source = params[:user]["source"]
      projref = params[:user]["projref"]
      User.create(nu_params)
      # flash[:notice] = source
      if source == "org-page"
        # redirect_to org_path(current_user.org_id)

      else
        redirect_to new_org_project_task_path(current_user.org_id,projref)
      end


  end




private

  def nu_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :org_id, :status) 
  end
end
