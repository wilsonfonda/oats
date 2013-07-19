require 'spec_helper'

describe "User pages" do

  subject { page }

  shared_examples_for "dynamic pages" do
    it { should have_selector('header') }
    it { should have_selector('footer') }
    it { should have_selector('div.container') }
    it { should have_selector('h1', text: heading) }
  end

  describe "Sign In page" do
    before { visit '/signin' }
    let(:heading){'Sign In'}
    it { should have_css('input#user_email') }
    it { should have_css('input#user_password') }
    it { should have_css('input#user_remember_me') }
    it { should have_link('Sign up', href: '/signup') }
    it { should have_link('Forgot your password?', href: '/users/password/new') }
    it { should have_button('Sign in') }
    it_should_behave_like "dynamic pages"
  end

  describe "Show page" do
    
    before { visit '/signin' }
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user1) }
      before do
        fill_in "user_email",    with: user.email.upcase
        fill_in "user_password", with: user.password
        click_button "Sign in"
      end

      before { visit user_path(user) }
      it { should have_selector('h1', text: 'Profile') }
      it { should have_link('Sign out', href: '/signout') }
      it { should_not have_link('Sign in', href: '/signin') }
    end
  end

end