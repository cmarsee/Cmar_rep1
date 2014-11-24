FactoryGirl.define do
	factory :user do
		sequence (:name) { |i| "User #{i}" }
		sequence (:email) { |l| "user.#{l}@example.com" }
		password "password"
        password_confirmation "password"
        
        factory :admin do
            admin true
        end
	  end
  
    factory :church do
      user
      name "Church"
      web_site "www.officialwebsite.com"
    end

    factory :service do
      church
      day_of_week "Monday"
      start_time "9:00"
      finish_time "10:00"
      location "Sanctuary"
    end

    factory :ride do
      user
      service
    end

    factory :user_ride do
      user
      ride
    end
end
