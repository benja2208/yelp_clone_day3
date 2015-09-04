require 'rails_helper'

feature 'reviewing' do
  context "reviewing" do
    before {Restaurant.create name: 'KFC'}
    
    scenario 'allows users to leave a review using a form' do
      
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'

      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so so')
    end
  end

  context 'limiting reviewing' do 
    let!(:user) { User.create(email: "Joe@joe.com", password: "testtest", password_confirmation: "testtest")}
    let!(:restaurant) { user.restaurants.create(name: 'KFC')}

    before do
      login_as(user)
    end

    scenario 'does not user to leave more than one review per restaurant' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so,so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "great man"
      select '5', from: 'Rating'
      click_button 'Leave Review'

      expect(page).not_to have_content('great man')
    end
  end

  context 'deleting your own review' do
    let!(:user) { User.create(email: "Joe@joe.com", password: "testtest", password_confirmation: "testtest")}
    let!(:restaurant) { user.restaurants.create(name: 'KFC')}

    before do
      login_as(user)
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so,so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Delete Review so,so'
    end

    scenario 'user can delete own review' do
      expect(current_path).to eq '/restaurants'
      expect(page).not_to have_content('so,so')
    end

  end
  context 'not being able to delete others review' do
    let!(:user) { User.create(email: "Joe@joe.com", password: "testtest", password_confirmation: "testtest")}
    let!(:user_1) { User.create(email: "Ben@ben.com", password: "testtest", password_confirmation: "testtest")}
    let!(:restaurant) { user.restaurants.create(name: 'KFC')}

    before do
      login_as(user)
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so,so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      logout :user
      login_as(user_1)
      click_link 'Delete Review so,so'
    end

    scenario 'user can delete own review' do
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('so,so')
    end

  end
end