namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_admin
    make_companies
    make_offices
    make_users
    make_worktimes
    make_billing
  end
end

def make_admin

name  = Faker::Name.name
    address = "test street"
    contact = "123123424"
    status  = "true"
    deposit = "0"
    Company.create!(name:     name,
                 address:    address,
                 contact: contact,
                 status: status,
                 deposit: deposit)
               
    companies = Company.all

    name  = Faker::Name.name
    companies.first.offices.create!(name: name, range: 100, latitude: 50, longitude: 60, latitude_min: "49", latitude_max: "51", longitude_min: "59", longitude_max: "61") 
      
   	access_token = Digest::SHA2.hexdigest("admin@email.com") + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    owner = companies.first.offices.first.users.create!(name: "admin", email: "admin@email.com", password: "123123", password_confirmation: "123123", division: "IT", access_token: access_token,role: "0")
        Ownership.create!(company_id: companies.first.id, owner_id: owner.id)

end

def make_users
    head, *tail = Company.all
    companies = tail
    n = 0
    companies.each do |company|
	    name  = Faker::Name.name
    	email = "owner-#{n+1}@email.com"
    	password  = "123123"
   	  access_token = Digest::SHA2.hexdigest(email) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      owner = company.offices.first.users.create!(name: name, email: email, password: "123123", password_confirmation: "123123", division: "IT", access_token: access_token, role: "1")
        Ownership.create!(company_id: company.id, owner_id: owner.id)
    	n = n+1
   end 
  
  i = 0
  j = 0
  3.times do |n|
      companies.each do |company|
        o =company.offices
	name  = Faker::Name.name
    	email = "hr-#{j+1}@email.com"
    	password  = "123123"
   	access_token = Digest::SHA2.hexdigest(email) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    o[i].users.create!(name: name, email: email, password: "123123", password_confirmation: "123123", division: "IT", access_token: access_token, role: "2")
        j = j +1
     end 
     i = i+1
   end
   
   i = 0
   k = 0
   3.times do|n|
   	companies.each do |company|
        o =company.offices
        	10.times do |m|
			name  = Faker::Name.name
    			email = "employee-#{k+1}@email.com"
    			password  = "123123"
   			access_token = Digest::SHA2.hexdigest(email) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    		o[i].users.create!(name: name, email: email, password: "123123", password_confirmation: "123123", division: "IT", access_token: access_token, role: "3")
    		  k = k +1
    		end
     	end 
     i = i+1
   end
end


def make_offices
  companies = Company.all
  3.times do
    companies.each do |company| 
    name  = Faker::Name.name
    company.offices.create!(name: name, latitude: -6.89059, longitude: 107.61709, 
      latitude_min: -6.8914883152841195, latitude_max: -6.889691684715881, longitude_min: 107.61618514903097, longitude_max: 107.61799485096904, range: 100) 
    end 
  end
end

def make_companies
  2.times do |n|
    name  = Faker::Name.name
    address = "test street"
    contact = "123123424"
    status  = "true"
    deposit = "0"
    Company.create!(name:     name,
                 address:    address,
                 contact: contact,
                 status: status,
                 deposit: deposit)
  end
end

def make_worktimes
    users = User.all[14..20]
    users.each do |user| 
      i = 240
      10.times do
        checkin = Time.now.advance(:hours => -i)
      	place_checkin = "Office checkin"
      	checkout = Time.now.advance(:hours => -i+(i/25))
      	place_checkout = "Office checkout"
	
        user.worktimes.create!(checkin: checkin, place_checkin: place_checkin, checkout: checkout, place_checkout: place_checkout) 
        i = i - 24
      end 
    end
end

def make_billing
    companies = Company.all
    company = companies.first
    company.billings.create!(month: 7, payment_date: "07-07-2013", price: 50, total_employee: 60)
end


