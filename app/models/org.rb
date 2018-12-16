class Org < ApplicationRecord
  validates :name, presence: true
  has_many :users
  has_many :projects
end
