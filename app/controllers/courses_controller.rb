class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy, :followers]
	before_filter :teacher_user,   only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def show
		@course = Course.find(params[:id])
	end

	def new
	end

	def create
		@course = current_user.courses.build(params[:course])
		if @course.save
			flash[:success] = "Course launched!"
			redirect_to root_url
		else
			@courselist_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@course.destroy
		redirect_to root_url
	end

	def followers
		@title = "Students"
		@course = Course.find(params[:id])
		@users = @course.follower_users.paginate(page: params[:page])
		render 'show_followers'
	end

	private

		# Clearly I don't know what I'm doing with this one...
		def teacher_user
			redirect_to(root_url) unless current_user.role == "teacher"
		end

		def correct_user
			@course = current_user.courses.find_by_id(params[:id])
			redirect_to root_url if @course.nil?
		end
end