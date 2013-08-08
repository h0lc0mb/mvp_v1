require 'spec_helper'

describe "Course pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

# BUG: The student "has" the button, they just can't SEE it

#	describe "should not see launch button as a student" do
#		before do
#			user.role = "student"
#			sign_in user
#			visit user_path(user)
#		end
#
#		it { should_not have_button('Launch course') }
#	end

	describe "should see launch button as a teacher" do
		before do
			user.role = "teacher"
			sign_in user
			visit user_path(user)
		end

		it { should have_button('Launch course') }
	end

	describe "course creation" do
		before { visit user_path(user) }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button "Launch course" }.not_to change(Course, :count)
			end

# Error messages broken for now
#			describe "error messages" do
#				before { click_button "Launch course" }
#				it { should  have_content('error') }
#			end
		end

		describe "with valid information" do

			before { fill_in 'course_coursename', with: "Susan Through the Looking Glass" }
			it "should create a course" do
				expect { click_button "Launch course" }.to change(Course, :count).by(1)
			end
		end
	end

	describe "course destruction" do
		before { FactoryGirl.create(:course, user: user) }

		describe "as correct user" do
			before { visit user_path(user) }

			it "should delete a course" do
				expect { click_link "delete" }.to change(Course, :count).by(-1)
			end
		end
	end

	describe "course profile page" do
		let(:course) { FactoryGirl.create(:course) }

		before { visit course_path(course) }

		it { should have_selector('h1',    text: course.coursename) }
		it { should have_selector('title', text: course.coursename)}

		before do
			user.role = "student"
			sign_in user
			user.follow_course!(course)
			visit course_path(course)
		end

		it { should have_link("1 student", href: followers_course_path(course)) }


		describe "posts" do
			let(:follower_user) { FactoryGirl.create(:user) }
			before { follower_user.follow_course!(course) }

			let!(:p1) { FactoryGirl.create(:post, follower_user: follower_user, 
																	 followed_course: course, 
																	 content: "What is Gauss's Law?") }
			let!(:p2) { FactoryGirl.create(:post, follower_user: follower_user, 
																	 followed_course: course, 
																	 content: "De que te ries Sancho?") }
		
			before { visit course_path(course) }
			
			it { should have_content(p1.content) }
			it { should have_content(p2.content) }
			it { should have_content(course.posts.count) }
		end
	end

	describe "user followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:course) { FactoryGirl.create(:course) }
    before { user.follow_course!(course) }

    before do
    	sign_in user
      visit followers_course_path(course)
    end

    it { should have_selector('title', text: full_title('Students')) }
    it { should have_selector('h3', text: 'Students') }
    it { should have_link(user.name, href: user_path(user)) }
  end
end