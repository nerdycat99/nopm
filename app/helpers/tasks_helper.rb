module TasksHelper

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
	def update_dependency_enddate_for(task_id, date_to_set, stack)
		dep_task_ids = get_dependencies_for(task_id)

		dep_task_ids.each do | task_id |
			task = Task.where(:id => task_id).first
			task.due_date = date_to_set
			task.save
			stack << task
		end

		if !stack.empty?
			next_task = stack.shift
			update_dependency_enddate_for(next_task.id, calculate_task_start_date(next_task.due_date,next_task.duration,false),stack)
		end

	end


	def get_dependencies_for(task_id)
		tasks = []
		dependencies = Prerequisite.where(:task_id => task_id)
		dependencies.each do | dependency |
			tasks << dependency.dependency_id
		end
		return tasks
	end

	def adjust_end_date_for(task_id,adjustment)
		task = Task.where(:id => task_id).first
		task.duration = 100
		task.save
	end


end
