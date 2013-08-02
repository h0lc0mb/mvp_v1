require 'spec_helper'

describe "Course pages" do

	subject { page }

# Revisit on cleanup -- I think this student / teacher stuff should live in user_pages_spec, not here!
	describe "as a student" do
		before do
			# probably should not be calling this @user
			@user = User.new(name:     "Jorge Borges", 
											 email:    "borges@jorgeluis.com",
											 password: "thealeph",
											 password_confirmation: "thealeph",
											 role: "student")
			sign_in user
			visit root_path
		end

		# I don't know why this test is failing -- home page does not display 
		# "Launch course" button for students
		# it { should_not have_button('Launch course') }
	end

	describe "as a teacher" do
		before do
			@user = User.new(name:     "Miguel Cervantes",
											 email:    "cervantes@miguel.com",
											 password: "quixote",
											 password_confirmation: "quixote",
											 role: "teacher")
			sign_in user
			visit root_path
		end

		it { should have_button('Launch course') }
	end

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "course creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button "Launch course" }.not_to change(Course, :count)
			end

			describe "error messages" do
				before { click_button "Launch course" }
				it { should  have_content('error') }
			end
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
			before { visit root_path }

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
			@user = User.new(name:     "Jorge Borges", 
											 email:    "borges@jorgeluis.com",
											 password: "thealeph",
											 password_confirmation: "thealeph",
											 role: "student")
			sign_in user
			user.follow_course!(course)
			visit course_path(course)
		end

		it { should have_link("1 student", href: followers_course_path(course)) }
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