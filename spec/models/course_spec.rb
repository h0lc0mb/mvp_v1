require 'spec_helper'

describe Course do

	let(:user) { FactoryGirl.create(:user) }
	before { @course = user.courses.build(coursename: "Susan Through the Looking Glass") }

	subject { @course }

	it { should respond_to(:coursename) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "accessible attributes" do
	it "shoud not allow access to user_id" do
		expect do
			Course.new(user_id: user.id)
		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
	end
end

	describe "when user_id is not present" do
		before { @course.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank coursename" do
		before { @course.coursename = " " }
		it { should_not be_valid }
	end

	describe "with coursename that is too long" do
		before { @course.coursename = "a" * 101 }
		it { should_not be_valid }
	end
end