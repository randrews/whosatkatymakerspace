class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable)

  has_many :visits
  has_one :active_visit, -> { where(active: true) }, class_name: 'Visit'
end
