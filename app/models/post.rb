class Post < ActiveRecord::Base
  attr_accessible :content, :followed_course_id

  belongs_to :followed_course, class_name: "Course"

  belongs_to :follower_user,   #through: :followed_course,
  											       class_name: "User"

  validates :follower_user_id, presence: true
  validates :followed_course_id, presence: true
  validates :content, presence: true, length: { maximum: 500 }

  default_scope order: 'posts.created_at DESC'

	def self.from_courses_followed_by(user)
		followed_course_ids = user.followed_course_ids
		launched_course_ids = user.course_ids
		where("followed_course_id IN (?) OR followed_course_id IN (?)", 
					followed_course_ids, launched_course_ids)
		#where("followed_course_id IN (?) OR follower_user_id = ?", followed_course_ids, user)
	end
end