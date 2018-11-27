class Performer::TasksController < ApplicationController

  include Performer::TasksHelper

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
    @users = User.all
  end

  def create
    parent_task = params[:task]["parent_task"]
    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(task_params)

    prerequisite = Prerequisite.create(:task_id => parent_task, :dependency_id => @task.id)
    prerequisite.save
 

    redirect_to performer_org_project_path(current_user.org_id,@project)
  end







  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
    @task.update_attributes(task_params)
    if @task.valid?
      redirect_to performer_org_project_path(current_user.org_id,@project)
    else
      return render :edit, status: :unprocessable_entity
    end
  end

    private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date, :duration, :deptasks) 
  end


end
