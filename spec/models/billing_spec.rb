# == Schema Information
#
# Table name: billings
#
#  id             :integer          not null, primary key
#  total_employee :integer
#  price          :integer
#  payment_date   :datetime
#  month          :integer
#  company_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Billing do
  let(:company) { FactoryGirl.create(:company) }
  before { @billing = company.billings.build(month:1,payment_date:"22-07-2013",price:1000,total_employee: 100) }

  subject { @billing }

  it { should respond_to(:month) }
  it { should respond_to(:payment_date) }
  it { should respond_to(:price) }
  it { should respond_to(:total_employee) }
  it { should respond_to(:company_id) }
  it { should respond_to(:company) }
  its(:company) { should == company }

  describe "accessible attributes" do
    it "should not allow access to company_id" do
      expect do
        Billing.new(company_id: company.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when company_id is not present" do
    before { @billing.company_id = nil }
    it { should_not be_valid }
  end
end
