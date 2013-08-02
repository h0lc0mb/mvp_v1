class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@course = Course.find(params[:relationship][:followed_course_id])
		current_user.follow_course!(@course)
		redirect_to @course
	end

	def destroy
		@course = Relationship.find(params[:id]).followed_course
		current_user.unfollow_course!(@course)
		redirect_to @course
	end
end