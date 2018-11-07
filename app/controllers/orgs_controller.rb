class OrgsController < ApplicationController

  def index
  end

  def new
    @org = Org.new
  end

  def show
    @org = current_user
  end

  def create
    @thisorg = Org.create(org_params)
    # redirect_to new_user_registration_path(:orgid => @thisorg)  
    redirect_to new_user_registration_path, flash: {org_name: @thisorg.name, org_id: @thisorg.id}

  end
  

  private

  def org_params
    params.require(:org).permit(:name, :description, :owner, :email) 
  end
end
