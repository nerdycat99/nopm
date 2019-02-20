module TasksHelper

	def get_parent_task_for(task)
		# in a pre-req the dependency_id is the child task and task_id is the parent
		pre_req = Prerequisite.where(:dependency_id => task.id).first
		parent_task = Task.where(:id => pre_req.task_id).first
	end

	def format_date_as_string_from(date)
		date.strftime("%d/%m/%Y")
	end

	def calculate_task_start_date(end_date,duration,as_string)
		if duration == nil
			return "no start date set"
		end
		# duration is days, we need to convert this to minutes to work with dates
		start_date = end_date - convert_to_seconds_from(duration)
		if as_string 
			return format_date_as_string_from(start_date)
		else
			return start_date
		end
	end 


	def convert_to_seconds_from(days)
		return days*((60*60)*24)
	end

	def convert_to_string_from(duration)
		if duration == nil
			return "duration not set"
		end
		return_string = ""
		duration > 1 ? return_string = duration.round.to_s + " days" : return_string = duration.round.to_s + " day"
		return return_string
	end


	def calculate_new_task_due_date_from(parent_task_id)
		parent_task = Task.where(:id => parent_task_id).first
		return calculate_task_start_date(parent_task.due_date,parent_task.duration,false)
	end


	# methods specific to Task Performer Actions
	def update_dependency_enddate_for(task_id, date_to_set,stack,dependency_tasks,manager)
		dep_task_ids = get_dependencies_for(task_id)

		dep_task_ids.each do | task_id |
			task = Task.where(:id => task_id).first
			task.due_date = date_to_set
			task.save
			stack << task
			dependency_tasks << task
		end

		if !stack.empty?
			next_task = stack.shift
			update_dependency_enddate_for(next_task.id, calculate_task_start_date(next_task.due_date,next_task.duration,false),stack, dependency_tasks,manager)
		else
			dependency_tasks.each do |dependency_task|
				notify_task_performer_manager_changed_project_end_date(dependency_task,manager)
			end
		end
	end


	def notify_task_performer_manager_changed_project_end_date(task,manager)
		# and generate a notification for each dependency task
		    recipient = User.where(:id => task.user_id).first
		    if manager 
		    	message = "project end date changed, task assigned to you has a new start date "
		    else
		    	message = "tasks that follow your task have changed, your task has a new start date"
		    end
		    notification = Notification.create(:recipient => recipient, :actor => current_user, :action => message, :notifiable => task)
		    notification.save
	end


	def get_dependencies_for(task_id)
		dep_tasks = []
		dependencies = Prerequisite.where(:task_id => task_id)
		dependencies.each do | dependency |
			dep_tasks << dependency.dependency_id
		end
		return dep_tasks
	end

	def adjust_end_date_for(task_id,adjustment)
		task = Task.where(:id => task_id).first
		task.duration = 100
		task.save
	end



end
