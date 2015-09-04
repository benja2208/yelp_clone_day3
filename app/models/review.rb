class Review < ActiveRecord::Base
	include AsUserAssociationExtention
  belongs_to :user
  belongs_to :restaurant
  
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }
end
