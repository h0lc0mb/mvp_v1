FactoryGirl.define do
	factory :user do
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"
		role "teacher"

		factory :admin do
			admin true
		end
	end

	factory :course do
		coursename "Susan Through the Looking Glass"
		user
	end

	factory :follower_user do
		user
	end

	factory :followed_course do
		course
	end

	factory :post do
		content "Is a dragon just a dinosaur that ate a spicy taco?"
		follower_user
		followed_course
#		user_id { course.user_id } # This will have to change once non-launchers can post
	end
end