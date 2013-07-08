# == Schema Information
#
# Table name: offices
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  longitude     :float
#  latitude      :float
#  longitude_min :float
#  latitude_min  :float
#  longitude_max :float
#  latitude_max  :float
#  range         :float
#  company_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Office do
  let(:company) { FactoryGirl.create(:company) }
  before { @office = company.offices.build(latitude:-90,longitude:-180,name:"Blah",range: 100,longitude_min:10,longitude_max:10,latitude_max:10,latitude_min:10) }

  subject { @office }

  it { should respond_to(:latitude) }
  it { should respond_to(:longitude) }
  it { should respond_to(:name) }
  it { should respond_to(:range) }
  it { should respond_to(:company_id) }
  it { should respond_to(:company) }
  it { should respond_to(:users) }
  its(:company) { should == company }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to company_id" do
      expect do
        Office.new(company_id: company.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when company_id is not present" do
    before { @office.company_id = nil }
    it { should_not be_valid }
  end
end
