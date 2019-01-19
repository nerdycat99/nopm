class Project < ApplicationRecord
  belongs_to :org
  has_many :tasks
  accepts_nested_attributes_for :tasks
end
