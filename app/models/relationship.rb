class Relationship < ActiveRecord::Base
  attr_accessible :followed_course_id

  belongs_to :follower_user,   class_name: "User"
  belongs_to :followed_course, class_name: "Course"

  validates :follower_user_id,   presence: true
  validates :followed_course_id, presence: true
end