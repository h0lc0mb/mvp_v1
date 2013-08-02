#require 'spec_helper'

#describe RelationshipsController do
#
#	let(:user) { FactoryGirl.create(:user) }
#	let(:course) { FactoryGirl.create(:course) }
#
#	before { sign_in user }
#
#	describe "creating a relationship with Ajax" do
#
#		it "should increment the Relationship count" do
#			expect do
#				xhr :post, :create, relationship: { followed_course_id: course.id }
#			end.to change(Relationship, :count).by(1)
#		end
#
#		it "should respond with success" do
#			xhr :post, :create, relationship: { followed_course_id: course.id }
#			response.should be_success
#		end
#	end
#
#	describe "destroying a relationship with Ajax" do
#
#		before { user.follow_course!(course) }
#		let(:relationship) { user.relationships.find_by_followed_course_id(course) }
#
#		it "should decrement the Relationship count" do
#			expect do
#				xhr :delete, :destroy, id: relationship.id
#			end.to change(Relationship, :count).by(-1)
#		end
#
#		it "should respond with success" do
#			xhr :delete, :destroy, id: relationship.id
#			response.should be_success
#		end
#	end
#end