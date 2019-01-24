class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  enum status: [:own, :mng, :tsk]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :encrypted_password, :presence => true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  belongs_to :org
  has_many :notifications, foreign_key: :recipient_id
end


