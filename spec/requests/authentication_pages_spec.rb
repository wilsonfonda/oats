require 'spec_helper'
require 'pp'
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
				fill_in "office_latitude", with: -60
				fill_in "office_longitude", with: -60
				fill_in "office_range", with: 50

				click_button "Create my account"
			end

			describe "home page (Owner)" do
		    	before { visit '/users' }
		    	it { should have_selector('h1', text: "Employees") }
				it { should have_selector('table') }
				it { should have_link('Example User', href: "/users/1") }
				it_should_behave_like "all dynamic pages"
			end  

			describe "edit profile page" do
		    	before { visit edit_user_path("1") }
		    	it { should have_selector('h1', text: "Profile") }
				it { should have_selector('h2', text: "Change Password") }
				it { should have_button("Save") }
				it { should have_link("Example User", href: user_path("1")) }
				it_should_behave_like "all dynamic pages"
			end

			describe "company page" do
		    	before { visit '/companies/1' }
		    	it { should have_selector('h1', text: "Company") }
		    	it { should have_link("Example User", href: user_path("1")) }
		    	it { should have_link("Edit Information", href: edit_company_path("1")) }
		    	it { should have_link("View Bills", href: "/billings?id=1") }
		    	it { should have_selector('h1', text: "Offices") }
		    	it { should have_selector('table#office-table') }
				it_should_behave_like "all dynamic pages"
			end

			describe "edit company page" do
		    	before { visit '/companies/1/edit' }
		    	it { should have_selector('h1', text: "Edit Company") }
		    	it { should have_selector('h1', text: "Offices") }
		    	it { should have_selector('table') }
		    	it { should have_selector('form#edit_company_1') }
				it_should_behave_like "all dynamic pages"
			end

			describe "performance page" do
		    	before { visit '/worktimes?id=1&from=05-07-2013&to=12-07-2013' }
		    	it { should have_selector('h1', text: "Example User's Performance") }
		    	it { should have_link("Example User", href: user_path("1")) }
		    	it { should have_selector('div#perf_chart') }
		    	it { should have_selector('input#datefrom') }
		    	it { should have_selector('input#dateto') }
		    	it { should have_selector('table') }
				it_should_behave_like "all dynamic pages"
			end

			describe "billings page" do
		    	before { visit '/billings?id=1' }
		    	it { should have_selector('h1', text: "Billings") }
		    	it { should have_selector('table') }
				it_should_behave_like "all dynamic pages"
			end
	  	end
  	end

  	describe "signin" do
	   	before { visit new_user_session_path }
	   	
	   	describe "with invalid information" do
	   		before { click_button "Sign in" }

		    it { should have_selector('h1', text: 'Sign In') }
	   	end


		describe "with valid information" do

			describe "with admin role" do
	    		let(:user) { FactoryGirl.create(:user2) }
=begin
			    before do
			        fill_in "user_email",        with: user.email
			        fill_in "user_password",     with: user.password
			        click_button "Sign in"
			    end

			    describe "home page (profile page)" do
			    	before { visit user_path(user) }
			    	it { should have_selector('h1', text: "Profile") }
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

				describe "company page" do
			    	before { visit company_path(user.office.company) }
			    	it { should have_selector('h1', text: "Company") }
			    	it { should have_link("Michael Hartl", href: user_path(user)) }
			    	it { should have_link("Edit Information", href: edit_company_path(user.office.company)) }
			    	it { should have_link("View Bills", href: "/billings?id="+user.office.company.id.to_s) }
			    	it { should have_selector('h1', text: "Offices") }
			    	it { should have_selector('table#office-table') }
					it_should_behave_like "all dynamic pages"
				end

				describe "edit company page" do
			    	before { visit edit_company_path(user.office.company) }
			    	it { should have_selector('h1', text: "Edit Company") }
			    	it { should have_selector('h1', text: "Offices") }
			    	it { should have_selector('table') }
			    	it { should have_selector('form#edit_company_'+user.office.company.id.to_s) }
					it_should_behave_like "all dynamic pages"
				end

				describe "performance page" do
			    	before { visit '/worktimes?id='+user.id.to_s+'&from=05-07-2013&to=12-07-2013' }
			    	it { should have_selector('h1', text: user.name+"'s Performance") }
			    	it { should have_link(user.name, href: user_path(user)) }
			    	it { should have_selector('div#perf_chart') }
			    	it { should have_selector('input#datefrom') }
			    	it { should have_selector('input#dateto') }
			    	it { should have_selector('table') }
					it_should_behave_like "all dynamic pages"
				end
=end
	    	end

	    	describe "with hr role" do
	    		let(:user) { FactoryGirl.create(:user1) }
			    before do
			        fill_in "user_email",        with: user.email
			        fill_in "user_password",     with: user.password
			        click_button "Sign in"
			    end

			    describe "home page (profile page)" do
			    	before { visit user_path(user) }
			    	it { should have_selector('h1', text: "Profile") }
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


				describe "performance page" do
			    	before { visit '/worktimes?id='+user.id.to_s+'&from=05-07-2013&to=12-07-2013' }
			    	it { should have_selector('h1', text: user.name+"'s Performance") }
			    	it { should have_link(user.name, href: user_path(user)) }
			    	it { should have_selector('div#perf_chart') }
			    	it { should have_selector('input#datefrom') }
			    	it { should have_selector('input#dateto') }
			    	it { should have_selector('table') }
					it_should_behave_like "all dynamic pages"
				end
	    	end

	    	describe "with employee role" do
	    		let(:user) { FactoryGirl.create(:user3) }
			    before do
			        fill_in "user_email",        with: user.email
			        fill_in "user_password",     with: user.password
			        click_button "Sign in"
			    end

			    describe "home page (profile page)" do
			    	before { visit user_path(user) }
			    	it { should have_selector('h1', text: "Profile") }
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

				describe "performance page" do
			    	before { visit '/worktimes?id='+user.id.to_s+'&from=05-07-2013&to=12-07-2013' }
			    	it { should have_selector('h1', text: user.name+"'s Performance") }
			    	it { should have_link(user.name, href: user_path(user)) }
			    	it { should have_selector('div#perf_chart') }
			    	it { should have_selector('input#datefrom') }
			    	it { should have_selector('input#dateto') }
			    	it { should have_selector('table') }
					it_should_behave_like "all dynamic pages"
				end
	    	end
	    end
  	end

end