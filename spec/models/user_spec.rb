# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
 
	before do
		@user = User.new(name: "Example User", email: "user@example.com",
										 password: "foobar", password_confirmation: "foobar",
										 role: "teacher")
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:role) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:courses) }
	it { should respond_to(:courselist) }
	it { should respond_to(:relationships) }
	it { should respond_to(:followed_courses) }
	it { should respond_to(:following_course?) }
	it { should respond_to(:follow_course!) }
	it { should respond_to(:unfollow_course!) }

	it { should be_valid }
	it { should_not be_admin }

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end

		it { should be_admin }
	end

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. 
										 foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate('invalid') }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "when no role is selected" do
		before { @user.role = " " }
		it { should_not be_valid }
	end

	describe "when role is teacher" do
		before { @user.role = "teacher" }
		it { should be_valid }
	end

	describe "when role is student" do
		before { @user.role = "student" }
		it { should be_valid }
	end

	describe "when role is not teacher or student" do
		before { @user.role = "football" }
		it { should_not be_valid }
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "course associations" do

		before { @user.save }
		let!(:older_course) do
			FactoryGirl.create(:course, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_course) do
			FactoryGirl.create(:course, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right courses in the right order" do
			@user.courses.should == [newer_course, older_course]
		end

		it "should destroy associated courses" do
			courses = @user.courses.dup
			@user.destroy
			courses.should_not be_empty
			courses.each do |course|
				Course.find_by_id(course.id).should be_nil
			end
		end

		describe "status" do
			let(:unfollowed_course) do
				FactoryGirl.create(:course, user: FactoryGirl.create(:user))
			end

			its(:courselist) { should include(newer_course) }
			its(:courselist) { should include(older_course) }
			its(:courselist) { should_not include(unfollowed_course) }
		end
	end

	describe "following courses" do
		let(:course_to_follow) { FactoryGirl.create(:course) }
		before do
			@user.save
			@user.follow_course!(course_to_follow)
		end

		it { should be_following_course(course_to_follow) }
		its(:followed_courses) { should include(course_to_follow) }

		describe "and unfollowing courses" do
			before { @user.unfollow_course!(course_to_follow) }

			it { should_not be_following_course(course_to_follow) }
			its(:followed_courses) { should_not include(course_to_follow) }
		end
	end
end