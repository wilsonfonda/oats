require 'spec_helper'

describe Presence do
  let(:user) { FactoryGirl.create(:user1) }
  before do
    @presence = user.presences.build(date: "2013-07-22", flag: "true", note: " ")
  end

  subject { @presence }

  it { should respond_to(:date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:note) }
  it { should be_valid }

  describe "when date is not present" do
    before { @presence.date = " " }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @presence.user_id = "" }
    it { should_not be_valid }
  end
end