class PostsController < ApplicationController
	before_filter :signed_in_user

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

		# v1.0: gives undefined method [] for nil:NilClass
#		@followed_course = Course.find(params[:relationship][:followed_course_id])
		# v1.1: gives couldn't find Course without an ID --THIS IS THE ONE I LIKE
#		@followed_course = Course.find(params[:post][:followed_course_id])
		# v1.2: gives couldn't find Course without an ID
#		@followed_course = Course.find(params[:id])
		# v1.3: gives couldn't find Post without ID (duh)
#		@followed_course = Post.find(params[:id]).followed_course_id
		# v1.4: couldn't find Course without an ID
#		@followed_course = Course.find(params[:followed_course_id])
		# v1.5: couldn't find Course without an ID
#		@followed_course = Course.find(params[:course_id])

		@post = current_user.posts.build(params[:post])
		@course = @post.followed_course

#		@followed_course = Course.find(params[:id])
#		@post = @followed_couse.posts.build(params[:post])
#		@post.follower_user = current_user
#		p params
#		p @post.follower_user
#		p @post.followed_course

#		@followed_course = Course.find(params[:relationship][:followed_course_id])
#		current_user.follow_course!(@followed_course)
#		@post = current_user.posts.build(params[:post]) #.merge(followed_course_id: followed_course.id))
#		p params
#		p @post.follower_user
#		p @post.followed_course

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
	end
end