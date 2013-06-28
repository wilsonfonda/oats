class Ability
	include CanCan::Ability
	
	def initialize(user)
		if user.role == '0'
			can :manage, :all
		elsif user.role == '1'
			can :read, Company do |company|
				Ownership.find_by_owner_id(user).company_id == company.id
			end
			can :update, Company do |company|
				Ownership.find_by_owner_id(user).company_id == company.id
			end
			can :read, Billing do |billing|
				Ownership.find_by_owner_id(user).company_id == billing.company_id
			end
			can :manage, Office do |office|
				Ownership.find_by_owner_id(user).company_id == office.company_id
			end
			can :manage, User do |employee|
				Ownership.find_by_owner_id(user).company_id == employee.company_id
			end
			cannot :change_status, Company
		elsif user.role == '2'
			can :manage, User do |employee|
				Ownership.find_by_owner_id(user).company_id == employee.company_id
			end
			cannot :change_role, User
			can :manage, Worktime do |worktime|
				worktime.user_id = user.id
			end
		else
			can :read, User do |employee|
				user == employee
			end
			can :update, User do |employee|
				user == employee
			end
			can :manage, Worktime do |worktime|
				worktime.user_id = user.id
			end
		end
	end
end