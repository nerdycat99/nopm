class RegistrationsController < Devise::RegistrationsController

  # def create
    # @thisuser = User.create(sign_up_params)
    # redirect_to org_path(@thisuser.org_id)
  # end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :org_id)  
  end


  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end


  def after_sign_in_path_for(users)
    org = current_user.org_id
    org_path(org)
    # test_path
  end

end


