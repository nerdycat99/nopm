module OrgsHelper

	def calculate_end_date_for(project)
		 return get_final_task_for(project).due_date.strftime("%d/%m/%Y")
	end


	def determine_status_for(project)

		status = ""

		first_tasks = find_first_tasks_for(project)

		# If any of the first tasks is not accepted yet, assume planning, otherwise set 
		# return value to In Progress, only return when looked at all first_tasks.
		# NB: the moment we hit any not yet accepted we can jump out of the loop and return planning
		first_tasks.each do |task|
			if task.status != "ACP"
				status = "PLANNING"
				return status
			else
				status = "IN PROGRESS"
			end
		end
		return status
	end


	def find_first_tasks_for(project)

		first_tasks = []

		all_paths = []
		path = []

		# use calculated endpoint to create dependency map and then derive all
		# unique paths as an array of arrays
		endpoint = get_final_task_for(project)
		dep_map = build_dependencies_from(endpoint)
		task_pairs = dep_map.reverse.each { |x| puts x }
    unique_paths = get_all_unique_paths(all_paths, path, task_pairs)


    # for each path get first value in the array, this will be the start task
    unique_paths.each do |path|
    	first_tasks << path[0]
    end
    return first_tasks

	end


	def get_final_task_for(project)
		project.tasks.each do |task| 
			if is_endpoint(task)
				return task
			end
		end
	end







end
