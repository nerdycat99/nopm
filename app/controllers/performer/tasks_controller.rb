class Performer::TasksController < ApplicationController

  include Performer::TasksHelper

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
    @users = User.where(:org_id => current_user.org_id)
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
      previous_duration = @task.duration
      change_to(previous_duration)
      redirect_to performer_org_project_path(current_user.org_id,@project)
    else
      return render :edit, status: :unprocessable_entity
    end
  end


  def change_to(previous_duration)
    if @task.duration == previous_duration
      # duration changed, change all dependencies
      new_start_date = helpers.calculate_task_start_date(@task.due_date,@task.duration,false)
      stack = []
      helpers.update_dependency_enddate_for(@task.id,new_start_date,stack)

    end
  end



  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date, :duration, :deptasks) 
  end


end
