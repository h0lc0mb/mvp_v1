class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following]
	before_filter :correct_user,   only: [:edit, :update]
	before_filter :admin_user,     only: :destroy

	def show
		@user = User.find(params[:id])
		@courses_launched = @user.courses.paginate(page: params[:page])
		@courses_joined = @user.followed_courses.paginate(page: params[:page])
		@course = current_user.courses.build if signed_in?
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to C4"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

	def following
		@title = "Courses Joined"
		@user = User.find(params[:id])
		@courses = @user.followed_courses.paginate(page: params[:page])
		render 'show_following'
	end

	def launched
		@title = "Courses Launched"
		@user = User.find(params[:id])
		@courses = @user.courses.paginate(page: params[:page])
		render 'show_launched'
	end

	private

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end