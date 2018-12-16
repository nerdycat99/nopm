class Performer::PrerequisitesController < ApplicationController

  include ProjectsHelper

  def new
    @project = Project.find(params[:project_id])
    @prerequisite = Prerequisite.new
  end

  def create
    @project = Project.find(params[:project_id])
    @prerequisite = Prerequisite.create(prerequisite_params)
    redirect_to performer_org_project_path(current_user.org_id,@project)
  end

  def destroy
  end

  private

  def prerequisite_params
    params.require(:prerequisite).permit(:task_id, :dependency_id) 
  end

end
