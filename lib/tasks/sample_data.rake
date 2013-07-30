namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
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
end