class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.build_review review_params, current_user

    if @review.save
    redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end
 

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.destroy_as_user(current_user)
      flash[:notice] = 'Review deleted successfully'
    else
      flash[:notice] = 'Error! You must be the creator to delete this entry.'
    end 
    redirect_to restaurants_path
  end

end
