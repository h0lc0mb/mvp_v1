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
end