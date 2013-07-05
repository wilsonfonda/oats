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
    it { should have_link('Sign up', href: '/users/sign_up') }
    it { should have_link('Forgot your password?', href: '/users/password/new') }
    it { should have_button('Sign in') }
    it_should_behave_like "dynamic pages"
  end

  describe "Show page" do
    before { visit user_path(@user) }
     describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end

end