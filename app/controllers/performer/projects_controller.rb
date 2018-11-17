class Performer::ProjectsController < ApplicationController

  before_action :authenticate_user!

  def show
    @project = Project.find(params[:id])
  end


end
