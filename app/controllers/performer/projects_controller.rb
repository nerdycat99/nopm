class Performer::ProjectsController < ApplicationController

  before_action :authenticate_user!

  include TasksHelper
  
  def show
    @project = Project.find(params[:id])
  end


end
