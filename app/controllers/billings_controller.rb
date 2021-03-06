class BillingsController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def index
		if (params[:id].nil?)
			if (can? :index, Billing.first)
				@billings = Array.new()
				Company.all.each do |company|
					@billing = Billing.find_by_company_id(company)
					if !@billing.nil?
						@billings.push(@billing)
					end
				end
			else
				redirect_to billings_path+"?id="+current_user.company_id.to_s
			end
		else
			if Billing.find_by_company_id(params[:id]).nil? || (can? :read, Billing.find_by_company_id(params[:id]))
				if (current_user.role == '0' || params[:id] == current_user.company_id.to_s)
					@offices = Company.find(params[:id]).offices
					@users = User.where("office_id IN (?)",@offices)
					@billings = Billing.where("company_id = ?", params[:id])
				else
					redirect_to billings_path+"?id="+current_user.company_id.to_s
				end
			else
				redirect_to billings_path+"?id="+current_user.company_id.to_s
			end
		end
	end

	def create
		@company = Company.find(params[:company_id])
		@billing = @company.billings.build()
		@billing.month = params[:month]
		@billing.payment_date = nil
		@billing.price = params[:price]
		@billing.total_employee = params[:total_employee]
		if @billing.save
			flash[:notice] = "Bill created."
		else
			flash[:error] = "Failed to create bill."
		end
		redirect_to :back
	end

	def update
		@billing = Billing.find(params[:id])
		@billing.update_attribute("payment_date",params[:billing][:payment_date])
		flash[:notice] = "Payment date updated."
		redirect_to :back
	end

	def destroy	
		Billing.find(params[:id]).destroy
		flash[:notice] = "Bill deleted."
        redirect_to :back
	end

end