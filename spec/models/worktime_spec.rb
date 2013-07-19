# == Schema Information
#
# Table name: worktimes
#
#  id             :integer          not null, primary key
#  checkin        :datetime
#  checkout       :datetime
#  place_checkin  :string(255)
#  place_checkout :string(255)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Worktime do
  let(:user) { FactoryGirl.create(:user1) }
  before { @worktime = user.worktimes.build(checkin:Time.now, checkout:Time.now.advance(:hours => 1), place_checkin:"bandung", place_checkout:"jakarta") }

  subject { @worktime }

  it { should respond_to(:checkin) }
  it { should respond_to(:checkout) }
  it { should respond_to(:place_checkin) }
  it { should respond_to(:place_checkout) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  describe "accessible attributes" do
    it "should not allow access to company_id" do
      expect do
        Worktime.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when company_id is not present" do
    before { @worktime.user_id = nil }
    it { should_not be_valid }
  end
end
