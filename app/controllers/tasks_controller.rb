class TasksController < ApplicationController

  # task controller for managers

  skip_before_action :verify_authenticity_token

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
    @users = User.all
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(task_params)
    # redirect_to org_project_path(current_user.org_id,@project)
    redirect_to org_path(current_user.org_id)
  end

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
  end


  def update
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
    @task.update_attributes(task_params)

    if @task.valid?
      previous_due_date = @task.due_date
      change_to(previous_due_date)
      redirect_to org_project_path(current_user.org_id,@project.id)
    else
      return render :edit, status: :unprocessable_entity
    end
  end


  def change_to(previous_due_date)
    if @task.due_date == previous_due_date
      # duration changed, change all dependencies
      new_start_date = helpers.calculate_task_start_date(@task.due_date,@task.duration,false)
      stack = []
      helpers.update_dependency_enddate_for(@task.id,new_start_date,stack)

    end
  end





  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date) 
  end

end
