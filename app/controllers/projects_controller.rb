class ProjectsController < ApplicationController

  def new
    # @project = Project.new
    @org = Org.find(params[:org_id])
    @project = Project.new 
  end

  def create
    @org = Org.find(params[:org_id])
    @project = @org.projects.create(project_params)
    redirect_to org_path(@org)
  end

  def show
    @project = Project.find(params[:id])
  end


  def edit
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :status) 
  end

end
