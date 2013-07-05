FactoryGirl.define do
    factory :company do
    	address "Pisang 21"
    	contact "0819812492174"
    	deposit "0"
    	name "Shit"
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
        password "foobar"
        password_confirmation "foobar"
        name     "Michael Hartl"
        division "IT"
        email    "michael@example.com"
        role "2"
        access_token "xxxx"
        office
    end

    factory :ownership do
        company
        user
    end
end
