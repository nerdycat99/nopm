class Project < ApplicationRecord
  belongs_to :org
  has_many :tasks
end
