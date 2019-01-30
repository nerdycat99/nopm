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

    # on success create a pre-requisite that attaches new task to its parent
    prerequisite = Prerequisite.create(:task_id => parent_task, :dependency_id => @task.id)
    prerequisite.save

    # and generate a notification to the new tasks performer
    recipient = User.where(:id => @task.user_id).first
    message = "#{current_user.first_name} has assigned a new task to you"
    notification = Notification.create(:recipient => recipient, :actor => current_user, :action => message, :notifiable => @task)
    notification.save
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
    # get the status and duration of task prior to its update - use for comparison to determine notification
    previous_status = @task.status
    previous_duration = @task.duration
    @task.update_attributes(task_params)
    
    if @task.valid?
      send_notification_if_performer_accepted_task(previous_status)
      process_change_to(previous_duration)
      redirect_to performer_org_project_path(current_user.org_id,@project)
    else
      return render :edit, status: :unprocessable_entity
    end
  end


  def send_notification_if_performer_accepted_task(previous_status)
    # notify the manager of the project that TP accepted task / TP of parent task
    if previous_status == "NEW" && @task.status == "ACP"
      
      if helpers.is_endpoint(@task)
        recipient = User.where(:id => @project.manager).first
        notification_object = @project
      else
        parent = helpers.get_parent_task_for(@task)
        recipient = User.where(:id => parent.user_id).first
        notification_object = @task
      end 
      
      message = "#{current_user.first_name} has accepted the task you created"
      notification = Notification.create(:recipient => recipient, :actor => current_user, :action => message, :notifiable => notification_object)
      notification.save

    end
  end


  def process_change_to(previous_duration)
    if previous_duration != nil && @task.duration != previous_duration
      # duration changed, change all dependencies
      new_start_date = helpers.calculate_task_start_date(@task.due_date,@task.duration,false)
      stack = []
      dependency_tasks = []
      helpers.update_dependency_enddate_for(@task.id,new_start_date,stack,dependency_tasks,false)

    end
  end



  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date, :duration, :deptasks) 
  end


end
