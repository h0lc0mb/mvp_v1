class Course < ActiveRecord::Base
  attr_accessible :coursename
  has_many :reverse_relationships, foreign_key: "followed_course_id",
  																 class_name:  "Relationship",
  																 dependent:   :destroy
  has_many :follower_users, through: :reverse_relationships, source: :follower_user
  belongs_to :user
  
  validates :coursename, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  default_scope order: 'courses.created_at DESC'
end