require 'spec_helper'

describe "StaticPages" do

	subject { page }
	
	describe "Home page" do

		before { visit root_path }

		it { should have_selector('h1', text: 'C4') }
		it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector('title', text: '| Home') }

    describe "for signed-in users" do
    	let(:user) { FactoryGirl.create(:user) }
    	before do
    		FactoryGirl.create(:course, user: user, coursename: "Cervantes 101")
    		FactoryGirl.create(:course, user: user, coursename: "Borges 201")
    		sign_in user
    		visit root_path
    	end

    	it "should render the user's 'courses launched' list" do
    		user.courselist.each do |item|
    			page.should have_selector("li##{item.id}", text: item.coursename)
    		end
    	end

    	describe "courses following count" do
    		let(:course_to_follow) { FactoryGirl.create(:course) }
    		before do
    			user.follow_course!(course_to_follow)
    			visit root_path
    		end

    		it { should have_link("1 courses joined", href: following_user_path(user)) }
    	end
    end
	end

	describe "Help page" do

		before { visit help_path }

		it { should have_selector('h1', text: 'Help') }
		it { should have_selector('title', text: "C4 | Help") }
	end

	describe "About page" do

		before { visit about_path }

		it { should have_selector('h1', text: 'About Us') }
		it { should have_selector('title', text: "C4 | About Us") }
	end

	describe "Contact page" do

		before { visit contact_path }

		it { should have_selector('h1', text: 'Contact') }
		it { should have_selector('title', text: "C4 | Contact") }
	end
end