module ProjectsHelper

  def is_endpoint(task)
    upstream = Prerequisite.where(:dependency_id => task.id)
    upstream.count < 1 ? true : false
  end


  def build_dependencies_from(root)
    dep_map = []
    stack =[]
    generate_dep_map(root, dep_map, stack)
  end


  def generate_dep_map(task, output, stack)

    if output.count < 1 
      output << [nil,task]
    end
    
    task.dependencys.each do |dependency|
      stack << dependency
      output << [task,dependency]
    end

    if stack.count >= 1
      next_task = stack.shift
      generate_dep_map(next_task, output, stack)
    else
      return output
    end

  end



  def arrange_dependencies_from(dep_map)

    tasks_visited = {} 
    # reverse the order of the map of dependencies and pass in where we've been and where we need to go
    tasks_from_start = dep_map.reverse.each { |x| puts x }
    arrange_rest_of_dependencies(tasks_visited, tasks_from_start)

  end


  def arrange_rest_of_dependencies(tasks_visited, remaining_tasks)
    
    if remaining_tasks.count <= 1
      return tasks_visited
    end
    # get next set of tasks from array
    next_set = remaining_tasks.shift

    # if the 'outer task' isn't one we've already encountered add task to unique list of tasks (tasks_visited)
    # if both inner and outer are new then set outer as 0 and inner as 1
    # else use the 'inner task' (i.e what follows task) and set it back one level
    if !tasks_visited.key?(next_set[1]) && !tasks_visited.key?(next_set[0])
      tasks_visited[next_set[1]] = 0
      tasks_visited[next_set[0]] = 1
    else
      if !tasks_visited.key?(next_set[1])
        tasks_visited[next_set[1]] = tasks_visited[next_set[0]]-1
      end
    end

    # if the inner task has not been encountered then simply set it to the outer +1
    # if the inner task has been set, check whether outer + 1 is greater than current value, if so set to higher
    if !tasks_visited.key?(next_set[0])
      tasks_visited[next_set[0]] = tasks_visited[next_set[1]]+1
    else
      if tasks_visited[next_set[0]] < tasks_visited[next_set[1]]+1
        tasks_visited[next_set[0]] = tasks_visited[next_set[1]]+1
      end
    end
    arrange_rest_of_dependencies(tasks_visited, remaining_tasks)

  end




end
