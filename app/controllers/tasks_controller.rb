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

    if @task.save 
      recipient = User.where(:id => @task.user_id).first
      message = "#{current_user.first_name} has assigned a new task to you"
      notification = Notification.create(:recipient => recipient, :actor => current_user, :action => message, :notifiable => @task)
      notification.save
      redirect_to org_path(current_user.org_id)
    end
    
  end

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
  end


  def update
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id]) 
    previous_due_date = @task.due_date
    @task.update_attributes(task_params)

    if @task.valid?
      change_to(previous_due_date,@task)
      redirect_to org_project_path(current_user.org_id,@project.id)
    else
      return render :edit, status: :unprocessable_entity
    end
  end


  def change_to(previous_due_date,end_task)
    if @task.due_date != previous_due_date

      # manager changed project end date - ergo due date has changed for @task, notify TP of @task...
      helpers.notify_task_performer_manager_changed_project_end_date(end_task,true)
      
      # ... and notify all TPs for all dependencies of @task (i.e the last task)
      new_start_date = helpers.calculate_task_start_date(@task.due_date,@task.duration,false)
      stack = []
      dependency_tasks = []
      helpers.update_dependency_enddate_for(@task.id,new_start_date,stack,dependency_tasks,true)

    end
  end





  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date) 
  end

end
