class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy, :followers]
	before_filter :teacher_user,   only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def show
		@course = Course.find(params[:id])
		@posts = @course.posts.paginate(page: params[:page])
		@post = current_user.posts.build if signed_in?
	end

	def new
	end

	def create
		@course = current_user.courses.build(params[:course])
		if @course.save
			flash[:success] = "Course launched!"
			redirect_to current_user
			#redirect_to root_url
		else
			@courselist_items = []
			#render 'users/show'
			#render 'static_pages/home'
			# Once again, I cannot figure out how to get the error messages to work in here
			redirect_to current_user
		end
	end

	def destroy
		@course.destroy
		redirect_to current_user
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

# Trying to define teacher / student creation for testing
#		def new_teacher
#			@teacher = User.new(name:     "Miguel Cervantes",
#											 email:    "cervantes@miguel.com",
#											 password: "quixote",
#											 password_confirmation: "quixote",
#											 role: "teacher")
#		end
#
#		def new_student
#			@student = User.new(name:     "Jorge Borges", 
#											 email:    "borges@jorgeluis.com",
#											 password: "thealeph",
#											 password_confirmation: "thealeph",
#											 role: "student")
#		end
end