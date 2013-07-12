FactoryGirl.define do
    factory :company do
    	address "aaa 21"
    	contact "0819812492174"
    	deposit "0"
    	name "aaa"
    	status "true"
    end

    factory :office do
     	latitude -89
        latitude_min -90
        latitude_max -88.9
        longitude -179
        longitude_min -180
        longitude_max -178.9
    	name "Blah"
    	range 100
    	company
    end

    factory :user do

        factory :user1 do
            password "foobar"
            password_confirmation "foobar"
            name     "Michael Hartl"
            division "IT"
            email    "hr@example.com"
            role "2"
            access_token "xxxx"
            office
        end

        factory :user2 do
            password "foobar"
            password_confirmation "foobar"
            name     "admin"
            division "IT"
            email    "admin@new.com"
            role "0"
            access_token "xxxx"
            office
        end

        factory :user3 do
            password "foobar"
            password_confirmation "foobar"
            name     "Michael Hartl"
            division "IT"
            email    "employee@example.com"
            role "3"
            access_token "xxxx"
            office
        end
    end

    

    factory :ownership do
        company_id 1
        owner_id 1
    end
end
