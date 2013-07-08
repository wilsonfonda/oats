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
			cannot :destroy, Office do |office|
				user.office_id == office.id
			end
		else
			if (user.office_id.nil?)
				can :mobile_signin, User
				can :create, Worktime
				can :update, Worktime
				can :mobile_graph, Worktime
			else
				if Company.find(user.company_id).status
					if user.role == '1'
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
						cannot :destroy, Office do |office|
							user.office_id == office.id
						end
						cannot :change_status, Company
						can :manage, Worktime do |worktime|
							worktime.user_id == user.id
						end
						can :create, Worktime
						can :read, Worktime do |worktime|
							User.find(worktime.user_id).company_id == user.company_id
						end
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
						can :read, Worktime do |worktime|
							User.find(worktime.user_id).company_id == user.company_id
						end
					elsif user.role == '3'
						can :manage, User do |employee|
							user == employee
						end
						cannot :change_role, User
						cannot :destroy, User
						cannot :index, User
						can :manage, Worktime do |worktime|
							worktime.user_id == user.id
						end
						can :create, Worktime
					end
				else
					if user.role == '1'
						can :read, Company do |company|
							Ownership.find_by_owner_id(user).company_id == company.id
						end
						can :read, Billing do |billing|
							Ownership.find_by_owner_id(user).company_id == billing.company_id
						end
						can :read, Office do |office|
							Ownership.find_by_owner_id(user).company_id == office.company_id
						end
						can :read, User do |employee|
							user == employee
						end
					elsif user.role == '2'
						can :read, User do |employee|
							user == employee
						end
					elsif user.role == '3'
						can :read, User do |employee|
							user == employee
						end
					end
				end
			end
		end
	end
end