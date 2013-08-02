require 'spec_helper'

describe Relationship do

	let(:follower_user) { FactoryGirl.create(:user) }
	let(:followed_course) { FactoryGirl.create(:course) }
	let(:relationship) { follower_user.relationships.build(followed_course_id: followed_course.id) }

	subject { relationship }

	it { should be_valid }

	describe "accessible attributes" do
		it "should not allow access to user_follower_id" do
			expect do
				Relationship.new(follower_user_id: follower_user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "user follower methods" do
		it { should respond_to(:follower_user) }
		it { should respond_to(:followed_course) }
		its(:follower_user)   { should == follower_user }
		its(:followed_course) { should == followed_course }
	end

	describe "when followed course id is not present" do
		before { relationship.followed_course_id = nil }
		it { should_not be_valid }
	end

	describe "when follower user id is not present" do
		before { relationship.follower_user_id = nil }
		it { should_not be_valid }
	end
end