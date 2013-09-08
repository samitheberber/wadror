FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "foobar1"
    password_confirmation "foobar1"
  end

  factory :rating1, class: Rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end
end
