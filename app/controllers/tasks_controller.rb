class TasksController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(task_params)
    redirect_to org_project_path(current_user.org_id,@project)
  end

  def show
    @task = Task.find(params[:id])
  end


  private

  def task_params
    params.require(:task).permit(:title, :description, :status) 
  end

end
