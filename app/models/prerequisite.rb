class Prerequisite < ApplicationRecord
  belongs_to :task
  belongs_to :dependency, :class_name => "Task" 
end
