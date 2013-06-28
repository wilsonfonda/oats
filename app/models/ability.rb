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
			cannot :index, Company
			can :read, Billing do |billing|
				Ownership.find_by_owner_id(user).company_id == billing.company_id
			end
			can :manage, Office do |office|
				Ownership.find_by_owner_id(user).company_id == office.company_id
			end
			can :create, Office
			can :manage, User do |employee|
				Ownership.find_by_owner_id(user).company_id == employee.company_id && employee.role != '0' 
			end
			can :add, User
			cannot :change_status, Company
			can :read, Worktime
		elsif user.role == '2'
			can :manage, User do |employee|
				employee == user || (Office.find(user.office_id).company_id == employee.company_id && employee.role != '0' && employee.role != '1' && employee.role != '2')
			end
			cannot :destroy, User do |employee|
				employee == user
			end
			can :add, User
			cannot :change_role, User
			can :manage, Worktime do |worktime|
				worktime.user_id == user.id
			end
			can :read, Worktime
		else
			can :read, User do |employee|
				user == employee
			end
			can :update, User do |employee|
				user == employee
			end
			can :manage, Worktime do |worktime|
				worktime.user_id == user.id
			end
		end
	end
end