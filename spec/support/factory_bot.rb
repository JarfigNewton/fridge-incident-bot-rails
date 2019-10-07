# This will guess the User class
FactoryBot.define do
  factory :incident_free_counter do
    days_since_incident { 5 }
  end
end
