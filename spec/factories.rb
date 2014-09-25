FactoryGirl.define do
	factory :user do
		sequence (:name) { |i| "User #{i}" }
		sequence (:email) { |l| "user.#{l}@example.com" }
		password "password"
	end
end
