# == Schema Information
#
# Table name: ownerships
#
#  id         :integer          not null, primary key
#  company_id :integer
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Ownership do
  let(:user) { FactoryGirl.create(:user1) }
  let(:company) {Company.find(user.company_id)}
  before { @ownership = Ownership.new(company_id: company.id,owner_id: user.id)}
  
  subject { @ownership }

  it { should respond_to(:company_id) }
  it { should respond_to(:company) }
  it { should respond_to(:owner_id) }
  it { should respond_to(:owner) }
  its(:company) { should == company }
  its(:owner) { should == user }

  it { should be_valid }
end
