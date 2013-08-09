 class PostsController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user,   only: :destroy

	def create
		# Figure out the relevant course
		# Build a post through the current_user on the relevant course page
		# Execute if/else

		# Note: this version has some security issues
		# Fix by either:
			# 1. Figuring out how to define the right course w/in the create action here 
				#(see failed efforts below)
			# 2. Adding a nested resource to courses per this explanation:
				#http://stackoverflow.com/questions/6480713/how-to-get-the-post-id-in-rails

		@post = current_user.posts.build(params[:post])
		@course = @post.followed_course

		if @post.save
			flash[:success] = "Content posted!"
			redirect_to @course
		else
			# Not sure if these things are right...
			# Confusing bc course page lists posts as @posts
			  # while home page lists posts as @feed_items
			@feed_items = []
			@posts = []
			redirect_to @course
#			render 'courses/show'
		end
	end

	def destroy
		@post.destroy
		redirect_to root_url
	end

	private

		def correct_user
			@post = current_user.posts.find_by_id(params[:id])
			redirect_to root_url if @post.nil?
		end
end