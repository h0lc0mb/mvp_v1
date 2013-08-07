require 'spec_helper'

describe "Post pages" do

	subject { page }

	let(:follower_user) { FactoryGirl.create(:user) }
	let(:followed_course) { FactoryGirl.create(:course) }

	before { sign_in follower_user }
	before { follower_user.follow_course!(followed_course) }

	describe "post creation" do
		before { visit course_path(followed_course) }

		describe "with invalid information" do

			it "should not create a post" do
				expect { click_button "Post" }.not_to change(Post, :count)
			end

# Rendering course page with error message is currently broken.
#			describe "error messages" do
#				before { click_button "Post" }
#				it { should have_content('error') }
#			end
		end

		describe "with valid information" do

			before { fill_in 'post_content', with: "Who moved my cheese" }
			it "should create a post" do
				expect { click_button "Post" }.to change(Post, :count).by(1)
			end
		end
	end

	describe "view Post button" do
		before { visit course_path(followed_course) }

		describe "as a follower" do
			describe "they should see the Post button" do
				it { should have_button('Post') }
			end
		end

#		describe "as a non-follower" do
#			before { follower_user.unfollow_course!(followed_course) }

#			describe "they should not see the Post button" do
#				it { should_not have_button('Post') }
#			end
#		end
	end
end