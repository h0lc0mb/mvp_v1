# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :role
  has_secure_password
  has_many :courses, dependent: :destroy
  has_many :relationships, foreign_key: "follower_user_id", dependent: :destroy
  has_many :followed_courses, through: :relationships, source: :followed_course

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates_inclusion_of :role, in: %w(teacher student)

  def courselist
    # This is preliminary
    Course.where("user_id = ?", id)
  end

  def following_course?(course_to_follow)
    relationships.find_by_followed_course_id(course_to_follow.id)
  end

  def follow_course!(course_to_follow)
    relationships.create!(followed_course_id: course_to_follow.id)
  end

  def unfollow_course!(course_to_follow)
    relationships.find_by_followed_course_id(course_to_follow.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end