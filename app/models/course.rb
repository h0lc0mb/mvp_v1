class Course < ActiveRecord::Base
  attr_accessible :coursename
  belongs_to :user
  
  validates :coursename, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  default_scope order: 'courses.created_at DESC'
end
