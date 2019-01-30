class ProjectsController < ApplicationController

  skip_before_action :verify_authenticity_token

  include ProjectsHelper

  def new
    # @project = Project.new
    # @org = Org.find(params[:org_id])
    @project = Project.new 
    # @project.tasks.build
  end

  def create
    @org = Org.find(params[:org_id])
    # @org = current_user.org_id
    @project = @org.projects.create(project_params)
    render json: @project
    # redirect_to org_path(@org)
  end

  def show
    @project = Project.find(params[:id])
  end


  def edit
    @project = Project.find(params[:id])
    @project_end_date
    @endpoint_task
  end

  private

  def project_params
    @new_project = params.require(:project).permit(:name, :description, :manager, :status)
  end

end
