class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum status: [:own, :mng, :tsk]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, :encrypted_password, :presence => true
  belongs_to :org
end


