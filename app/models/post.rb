class Post < ActiveRecord::Base
  attr_accessible :content, :followed_course_id

  belongs_to :followed_course, class_name: "Course"

  belongs_to :follower_user,   #through: :followed_course,
  											       class_name: "User"

  validates :follower_user_id, presence: true
  validates :followed_course_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  default_scope order: 'posts.created_at DESC'
end