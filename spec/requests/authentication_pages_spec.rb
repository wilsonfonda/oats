require 'spec_helper'

describe "User pages" do

  subject { page }

    shared_examples_for "all dynamic pages" do
	    it { should have_selector('header') }
	    it { should have_selector('footer') }
	    it { should have_selector('div.container') }
		it { should have_link("Sign out", href: "/signout") }
	end

  	describe "signup page" do
	    before { visit signup_path }

	    it { should have_selector('h1',    text: 'Sign Up Now!') }
	    it { should have_link('Sign in', href:'/signin') }
	    it { should have_link('Forgot your password?', href: '/users/password/new') }

	    describe "with valid information" do
	    	before do
			    fill_in "name",         with: "Example User"
				fill_in "email",        with: "user@example.com"
				fill_in "password",     with: "foobar"
				fill_in "password_confirmation", with: "foobar"
				fill_in "division",         with: "foobar"
				fill_in "company_name",        with: "foobar"
				fill_in "company_address",     with: "foobar"
				fill_in "company_contact", with: "foobar"
				fill_in "office_name", with: "foobar"
				fill_in "office_latitude", with: -100
				fill_in "office_longitude", with: -150
				fill_in "office_range", with: 50

				click_button "Create my account"
			end

			describe "home page (Owner)" do
		    	before { visit '/users' }
		    	it { should have_selector('h1', text: "Employees") }
				it { should have_selector('table') }
				#it { should have_link("Example User", href: user_path("Example User")) }
				it_should_behave_like "all dynamic pages"
			end  

=begin			#masih belum jalan
			describe "edit profile page" do
		    	before { visit edit_user_path("Example User") }
		    	it { should have_selector('h1', text: "Profile") }
				it { should have_selector('h2', text: "Change Password") }
				it { should have_button("Save") }
				#it { should have_link("Example User", href: user_path("Example User")) }
				it_should_behave_like "all dynamic pages"
			end
=end


			describe "employees page" do
		    	before { visit '/users' }
		    	it { should have_selector('h1', text: "Employees") }
		    	#it { should have_link("Example User", href: user_path("Example User")) }
				it_should_behave_like "all dynamic pages"
			end
	  	end
  	end

  	describe "signin" do
  		let(:user) { FactoryGirl.create(:user) }
	   	before { visit new_user_session_path }
	   	
	   	describe "with invalid information" do
	   		before { click_button "Sign in" }

		    it { should have_selector('h1', text: 'Sign In') }
	   	end


		describe "with valid information" do
=begin
	    	describe "with owner role" do
	    		let(:owner) { FactoryGirl.create(:user, role: '1') }
	    		let(:ownership) { FactoryGirl.create(:ownership) }
			    before do
			        fill_in "user_email",        with: owner.email
			        fill_in "user_password",     with: owner.password
			        click_button "Sign in"
			    end

			    describe "home page (Employees)" do
			    	before { visit '/users' }
			    	it { should have_selector('h1', text: "Employees") }
					it { should have_selector('table') }
					it_should_behave_like "all dynamic pages"
				end     	
	    	end
=end

	    	describe "with other role" do
	    		let(:user) { FactoryGirl.create(:user) }
			    before do
			        fill_in "user_email",        with: user.email
			        fill_in "user_password",     with: user.password
			        click_button "Sign in"
			    end

			    describe "home page (profile page)" do
			    	before { visit user_path(user) }
			    	it { should have_selector('h1', text: "Employee Profile") }
					it { should have_selector('h2', text: "Check In") }
					it { should have_selector('div#timer') }
					it { should have_link(user.name, href: user_path(user)) }
					it_should_behave_like "all dynamic pages"
				end

				describe "edit profile page" do
			    	before { visit edit_user_path(user) }
			    	it { should have_selector('h1', text: "Profile") }
					it { should have_selector('h2', text: "Change Password") }
					it { should have_button("Save") }
					it { should have_link(user.name, href: user_path(user)) }
					it_should_behave_like "all dynamic pages"
				end

				describe "employees page" do
			    	before { visit '/users' }
			    	it { should have_selector('h1', text: "Employees") }
			    	it { should have_link(user.name, href: user_path(user)) }
					it_should_behave_like "all dynamic pages"
				end

=begin
				describe "My Performance Page" do
			    	before { visit '/worktimes' }
			    	it { should have_selector('h1', text: "Performance") }
					it_should_behave_like "all dynamic pages"
				end
=end
				
	    	end
	    end
  	end

end