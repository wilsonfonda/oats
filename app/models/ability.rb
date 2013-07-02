class Ability
	include CanCan::Ability
	
	def initialize(user)
		user ||= User.new

		if user.role == '0'
			can :manage, :all
			cannot :destroy, User do |admin|
				admin.role == '0'
			end
			cannot :destroy, Company do |company|
				Ownership.find_by_owner_id(user).company_id == company.id
			end
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
			cannot :destroy, User do |owner|
				user == owner
			end
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
			can :create, Worktime
			can :read, Worktime
		elsif user.role == '3'
			can :read, User do |employee|
				user == employee
			end
			can :update, User do |employee|
				user == employee
			end
			can :manage, Worktime do |worktime|
				worktime.user_id == user.id
			end
			can :create, Worktime
		else
			can :mobile_signin, User
			can :create, Worktime
			can :update, Worktime
			can :mobile_graph, Worktime
		end
	end
end