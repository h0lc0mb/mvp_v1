class Course < ActiveRecord::Base
  attr_accessible :coursename
  
  belongs_to :user

  has_many :reverse_relationships, foreign_key: "followed_course_id",
  																 class_name:  "Relationship",
  																 dependent:   :destroy

  has_many :follower_users,        through: :reverse_relationships, 
                                   source:  :follower_user

  has_many :posts,                 # through: :follower_users, ** if you do this, remove belongs_to followed_course from post model
                                   foreign_key: "followed_course_id",
                                   dependent:   :destroy

  validates :coursename, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  default_scope order: 'courses.created_at DESC'
end