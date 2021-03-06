class OrgsController < ApplicationController

  skip_before_action :verify_authenticity_token

  include OrgsHelper

  def index
    render json: User.where(:org_id => current_user.org_id)
  end

  def new
    @org = Org.new
  end

  def show
    # changed to be the current_user's org id
    @org = current_user.org_id
    @users = User.where(:org_id => current_user.org_id)
  end

  def edit
  end

  def create
    @thisorg = Org.create(org_params)
    # redirect_to new_user_registration_path(:orgid => @thisorg)  
    # redirect_to new_user_registration_path(:org => @thisorg.id, :user_type => 0), flash: {org_name: @thisorg.name, org_id: @thisorg.id, user_type: 0}
    # redirect_to new_user_registration_path(:org => @thisorg.id, :user => 0)
    # alt approach - redirect to splash for steps 2
    if @thisorg.invalid?
      #render :new, status: :unprocessable_entity
       # redirect_to register_space_path
      # flash[:error] = '<strong>cannot create space</strong> you need to give your organisation or company a name.'
    else
      redirect_to register_user_path(:org => @thisorg.id, :user => 0)
    end
    
  end
  

  private

  def org_params
    params.require(:org).permit(:name, :description, :owner, :email) 
  end
end
