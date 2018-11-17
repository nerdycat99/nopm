class TasksController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
    @users = User.all
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(task_params)
    redirect_to org_project_path(current_user.org_id,@project)
  end

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
  end



  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date) 
  end

end
