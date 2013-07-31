require 'spec_helper'

describe "Course pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }

	describe "course creation" do
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a course" do
				expect { click_button "Launch" }.not_to change(Course, :count)
			end

			describe "error messages" do
				before { click_button "Launch" }
				it { should  have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'course_coursename', with: "Susan Through the Looking Glass" }
			it "should create a course" do
				expect { click_button "Launch" }.to change(Course, :count).by(1)
			end
		end
	end
end