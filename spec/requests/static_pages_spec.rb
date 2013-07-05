require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('header') }
    it { should have_selector('footer') }
    it { should have_selector('div.container') }
    it { should have_selector('h1', text: heading) }
  end

  describe "Home page" do
    before { visit root_path }
    it { should_not have_selector 'h1', text: 'Home' }
    it { should have_button('Sign In') }
    it { should have_button('Register') }
  end

  describe "About page" do
    before { visit '/about' }
    let(:heading){'About Us'}
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
   before { visit '/contact' }
    let(:heading){'Contact Us'}
    it_should_behave_like "all static pages"
    it { should have_link('', href: 'https://www.facebook.com/pages/Oats/495179823887930') }
    it { should have_link('', href: 'https://twitter.com/oatsdaily') }
  end

  describe "Help page" do
    before { visit '/help' }
    let(:heading){'Help'}
    it_should_behave_like "all static pages"
  end

  describe "Privacy page" do
   before { visit '/privacy' }
    let(:heading){'Privacy Policy'}
    it_should_behave_like "all static pages"
  end

  describe "Testimony page" do
   before { visit '/testimony' }
    let(:heading){'Testimony'}
    it_should_behave_like "all static pages"
  end

end