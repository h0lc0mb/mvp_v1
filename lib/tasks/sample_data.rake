namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_courses
		make_relationships_and_posts
	end
end

def make_users
	admin = User.create!(name: "Blaise Pascal",
								 			 email: "pascal@blaise.com",
								 			 password: "scandale",
								 			 password_confirmation: "scandale",
								 			 role: "teacher")
	admin.toggle!(:admin)
	
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@c4students.com"
		password = "password"
		role = "student"
		User.create!(name: name,
								 email: email,
								 password: password,
								 password_confirmation: password,
								 role: role)
	end

	29.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@c4teachers.com"
		password = "password"
		role = "teacher"
		User.create!(name: name,
								 email: email,
								 password: password,
								 password_confirmation: password,
								 role: role)
	end
end

def make_courses
	users = User.all
	users.each do |user|
		if user.role == "teacher"
			5.times do
				coursename = Faker::Lorem.sentence(5)
				user.courses.create!(coursename: coursename)
			end
		end
	end
end

def make_relationships_and_posts
	users = User.all
	courses = Course.all
	follower_user = users.first
	followed_courses = courses[6..10]
	followed_courses.each { |followed_course| follower_user.follow_course!(followed_course) }
	followed_courses.each do |followed_course|
		10.times do
			content = Faker::Lorem.sentence(5)
			follower_user.posts.create!(content: content, followed_course_id: followed_course.id)
		end
	end
end












