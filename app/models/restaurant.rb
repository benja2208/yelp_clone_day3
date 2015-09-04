class Restaurant < ActiveRecord::Base
	include AsUserAssociationExtention

	belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :name, length: {minimum: 3}, uniqueness: true
  
  def build_review(attributes = {}, user)
    attributes[:user] ||= user
    reviews.build(attributes)
  end 
end
