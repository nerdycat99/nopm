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
    arrange_dependencies(tasks_visited, tasks_from_start)

  end


  def arrange_dependencies(tasks_visited, remaining_tasks)
    
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
    arrange_dependencies(tasks_visited, remaining_tasks)

  end




  def get_unique_paths(dep_map, return_valid_dep)
    all_paths = []
    path = []
    task_pairs = dep_map.reverse.each { |x| puts x }

    unique_paths = get_all_unique_paths(all_paths, path, task_pairs)

    if return_valid_dep 
      return unique_paths
    end 

    final_task = unique_paths[0][-1]
    vertical_order = []    
    unique_paths.each do |path| 
      path.pop # remove the last element which will be nil for each path
      final_task = path.last
      path.each_with_index do |task, index|
        if !vertical_order.include?(task) && task != final_task
          
          # check whether the next task is in the vertical_order array, if so get the position at which it appears
          if vertical_order.include?(path[index+1])
            at_position = vertical_order.index(path[index+1])
            vertical_order.insert(at_position, task)
          elsif vertical_order.include?(path[index-1])
            at_position = vertical_order.index(path[index-1])+1
            vertical_order.insert(at_position, task)
          else
            vertical_order.push(task)
          end
        end  
      end
    end

    vertical_order.push(final_task)
    return vertical_order
  end


  def get_all_unique_paths(all_paths, path, task_pairs)

    if all_paths.count < 1
      path.push(task_pairs[0][1])
      path.push(task_pairs[0][0]) 
      task_pairs.shift 
    else
      all_paths.each do |individual_path|
        individual_path.each_with_index do |task, index|
          if task_pairs.count < 1
            return all_paths 
          end
          if task_pairs[0][1] == task
            if task_pairs[0][0] == individual_path[index+1]
              # skip - the current position 1 task pair we've already been to in a previous path
              # drop this pair of paths from task_pairs and go again
              task_pairs.shift
              get_all_unique_paths(all_paths, path, task_pairs)
            end
          else
            # the current position 1 task is new, build a new path
            path = []    
            path.push(task_pairs[0][1])
            path.push(task_pairs[0][0]) 
            # push
          end
        end
      end
    end

    search_for = path.last

    task_pairs.each do |task_pair|
      if task_pair[1] == search_for
        path.push(task_pair[0])
        search_for = task_pair[0]
      end
    end

    all_paths.push(path)

    if task_pairs.count < 1
      return all_paths
    end

  #  task_pairs.shift REMOVED 26/11
    path = []
    get_all_unique_paths(all_paths, path, task_pairs)

  end



  def calculate_valid_dependecies_for_task(all_paths, target_task)

    valid_deps = []
    invalid_deps =[]
    holding_array = []

    # remove any array in which the target_task appears, these are the paths up/down where the target_task
    # is either a dependecy for a task or is dependent on a task
    all_paths.each_with_index do |path, index|
      path.pop # get rid of the nil at the end of each path
      path.each do |task|
        if task.id == target_task.to_i
          holding_array = invalid_deps + path
          invalid_deps = holding_array
          holding_array = []
          all_paths.delete_at(index)
        end
      end
    end

    # from all remaining arrays (paths) remove any item that exists in invalid_deps from each array
    # and return the remaining tasks in the form of unique array valid_tasks
    all_paths.each do |path|
      path.pop
      path.each_with_index do |task, index|
        if !invalid_deps.include?(task) && !valid_deps.include?(task)
          valid_deps << task
        end
      end
    end


    return valid_deps
  end












end
