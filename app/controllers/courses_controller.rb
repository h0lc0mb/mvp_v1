class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]

	def create
		@course = current_user.courses.build(params[:course])
		if @course.save
			flash[:success] = "Course launched!"
			redirect_to root_url
		else
			render 'static_pages/home'
		end
	end

	def destroy
	end
end