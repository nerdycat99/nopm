class RegistrationsController < Devise::RegistrationsController

  # def create
  #   @thisuser = User.create(sign_up_params)
  #   redirect_to org_path(@thisuser.org_id)
  #  end

  private

  def sign_up_params
    @thisuser = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :org_id, :status)  

  end


  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end


  def after_sign_in_path_for(users)
    org = current_user.org_id
    if current_user.own?
      org_path(org)
    elsif current_user.mng?
      org_path(org)
    else
      performer_org_path(org)
    end
  end

end


