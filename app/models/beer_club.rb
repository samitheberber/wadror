class BeerClub < ActiveRecord::Base
  has_many :memberships, conditions: {confirmed: true}
  has_many :members, through: :memberships, source: :user

  has_many :applications, conditions: {confirmed: [nil, false]}, class_name: 'Membership'
end
