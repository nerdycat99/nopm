class Task < ApplicationRecord
  belongs_to :project

  has_many :prerequisites
  has_many :dependencys, :through => :prerequisites
end
