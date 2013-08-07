require 'spec_helper'

describe Post do
  
  let(:follower_user) { FactoryGirl.create(:user) }
  let(:followed_course) { FactoryGirl.create(:course) }
  before { follower_user.follow_course!(followed_course) }

# This works...
  before { @post = follower_user.posts.build(content: "What is Gauss's law?", followed_course_id: followed_course.id) }

  subject { @post }

  it { should respond_to(:content) }
  it { should respond_to(:follower_user_id) }
  it { should respond_to(:followed_course_id) }
  it { should respond_to(:follower_user) }
  it { should respond_to(:followed_course) }
  its(:follower_user) { should == follower_user }
#  its(:followed_course) { should == followed_course }

  it { should be_valid }

  describe "accessible attributes" do
  	it "should not allow access to follower_user_id" do
  		expect do
  			Post.new(follower_user_id: follower_user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end

  describe "when follower_user_id is not present" do
  	before { @post.follower_user_id = nil }
  	it { should_not be_valid }
  end

  describe "when followed_course_id is not present" do
  	before { @post.followed_course_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
  	before { @post.content = " " }
  	it { should_not be_valid }
  end

  describe "with content that is too long" do
  	before { @post.content = "a" * 501 }
  	it { should_not be_valid }
  end
end