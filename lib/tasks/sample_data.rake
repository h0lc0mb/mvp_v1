namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_courses
		make_relationships
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

def make_relationships
	users = User.all
	courses = Course.all
	user = users.first
	followed_courses = courses[2..6]
	followed_courses.each { |followed_course| user.follow_course!(followed_course) }
end