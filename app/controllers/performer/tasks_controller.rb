class Performer::TasksController < ApplicationController

  include Performer::TasksHelper

  def new
    @project = Project.find(params[:project_id])
    @task = Task.new
    @users = User.where(:org_id => current_user.org_id)
    # remove this after modal working 
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
    redirect_back(fallback_location: root_path); # ensures page is reloaded and dropdown list is correct
    #redirect_to performer_org_project_path(current_user.org_id,@project)
  end







  def show
    @this_task = Task.find(params[:id])
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
    previous_task_performer = @task.user_id
    @task.update_attributes(task_params)
    
    if @task.valid?

      if performer_accepted_task?(previous_status, @task.status)
        message_string = "has accepted the task you created"
        notification_to_task_creator(message_string)
        redirect_to performer_org_project_task_path(current_user.org_id,@project,@task) and return
      end

      if performer_reassigned_task?(previous_task_performer, previous_status)
        message_string = "has re-assigned a task to you"
        notification_to_task_performer(message_string)
        message_string = "has re-assigned a task you created"
        notification_to_task_creator(message_string)
        redirect_to performer_org_project_path(current_user.org_id,@project) and return
      end

      if performer_rejected_task?(previous_status, @task.status)
        message_string = "has rejected a task you created"
        notification_to_task_creator(message_string)
        redirect_to performer_org_project_path(current_user.org_id,@project) and return
      end

      if duration_was_changed?(previous_duration)
        # duration changed, change all dependencies for task changed
        new_start_date = helpers.calculate_task_start_date(@task.due_date,@task.duration,false)
        stack = []
        dependency_tasks = []
        helpers.update_dependency_enddate_for(@task.id,new_start_date,stack,dependency_tasks,false)
        redirect_to performer_org_project_task_path(current_user.org_id,@project,@task) and return
      end
    else
      return render :edit, status: :unprocessable_entity
    end
  end



  def performer_reassigned_task?(previous_task_performer, previous_status)
    # notify the manager of the project that TP accepted task / TP of parent task
    if previous_status == "NEW" && @task.status == "REA" && previous_task_performer != @task.user_id || 
       previous_status == "REA" && @task.status == "REA" && previous_task_performer != @task.user_id || 
       previous_status == "REJ" && @task.status == "REA" && previous_task_performer != @task.user_id
      return true
    else
      return false
    end
  end

  def performer_accepted_task?(previous_status, new_status)
    # notify the manager of the project that TP accepted task / TP of parent task
    if previous_status == "NEW" && new_status == "ACP" || 
       previous_status == "REA" && new_status == "ACP" ||
       previous_status == "REJ" && new_status == "ACP"
      return true
    else
      return false
    end
  end

  def performer_rejected_task?(previous_status, new_status)
    if previous_status == "NEW" && new_status == "REJ" ||
       previous_status == "REA" && new_status == "REJ"
      return true
    else
      return false
    end

  end

  def notification_to_task_performer(message_string)
    recipient = User.where(:id => @task.user_id).first
    notification_object = @task
    message = "#{current_user.first_name} has re-assigned a task to you"
    send_notification(recipient,notification_object,message)
  end


  def notification_to_task_creator(message_string)
    if helpers.is_endpoint(@task)
        recipient = User.where(:id => @project.manager).first
        notification_object = @project
      else
        parent = helpers.get_parent_task_for(@task)
        recipient = User.where(:id => parent.user_id).first
        notification_object = @task
      end 
      message = "#{current_user.first_name} #{message_string}"
      send_notification(recipient,notification_object,message)
  end

  def send_notification(recipient,notification_object,message)
    notification = Notification.create(:recipient => recipient, :actor => current_user, :action => message, :notifiable => notification_object)
    notification.save
  end



  def duration_was_changed?(previous_duration)
    if previous_duration != nil && @task.duration != previous_duration
      return true
    else
      return false
    end
  end



  private

  def task_params
    params.require(:task).permit(:title, :description, :status, :user_id, :due_date, :duration, :deptasks) 
  end


end
