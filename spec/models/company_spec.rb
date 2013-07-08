# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  contact    :string(255)
#  status     :boolean
#  deposit    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Company do
  before do
    @company = Company.new(name: "Wilson Fonda", address: "Jl. Sekeloa", contact:"oatsdaily@gmail.com")
  end

  subject { @company }

  it { should respond_to(:name) }
  it { should respond_to(:offices) }
  it { should respond_to(:billings) }
  it { should respond_to(:ownership) }
  it { should be_valid }

  describe "when name is not present" do
    before { @company.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @company.name = "a" * 51 }
    it { should_not be_valid }
  end
end
