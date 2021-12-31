# frozen_string_literal: true

require 'test_helper'

class FlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
  fixtures :orders

  setup do
    @username = Faker::Internet.username
    @email = Faker::Internet.email
    @phone = Faker::PhoneNumber.cell_phone_with_country_code
    @password = Faker::Internet.password(min_length: 6)
  end

  test 'unauthorized user can visit root path' do
    get root_path
    assert_response :success
  end

  test 'unauthorized user will be redirected to login page' do
    get users_path
    assert_redirected_to controller: :session, action: :login
  end

  test 'user with incorrect credentials will be redirected to login page' do
    user = User.create(username: @username, email: @email, phone: @phone, password: @password, password_confirmation: @password)
    post session_create_url, params: { login: "#{user.username}f", password: "#{user.password}F" }
    assert_redirected_to controller: :session, action: :login
  end

  test 'user will see root page after signing up' do
    post users_path,
         params: { user: { username: @username, email: @email, phone: @phone,  password: @password, password_confirmation: @password } }
    assert_not_nil User.find_by(username: @username)
    assert_redirected_to root_path
  end

  test 'users should be able to login' do
    user = users(:one)
    user.save
    post session_create_url, params: { login: users(:one).username, password: 'Secret1' }

    assert_redirected_to root_path
  end

  test 'unauthorized user should be able to login' do
    post session_create_path, params: { login: users(:one).username, password: 'Secret1' }
    get session_logout_url
    assert_redirected_to controller: :session, action: :login
  end

  test 'user should be able to create orders' do
    # Generate order
    title = Faker::String.random(length: 3..12)
    description = Faker::String.random(length: 3..12)
    cost = Faker::Number.between(from: 1, to: 50)
    time_to_complete = Faker::Date.between(from: Date.today, to: '2022-02-01')

    post session_create_path, params: { login: users(:one).username, password: 'Secret1' }
    assert_difference('users(:one).orders.count') do
      post orders_path, params: { order: { title: title, description: description, cost: cost, time_to_complete: time_to_complete, user_id: users(:one).id } }
    end 
    assert_response :found
  end

  test 'user should be able to edit himself' do
    post session_create_path, params: { login: users(:one).username, password: 'Secret1' }
    patch user_path(users(:one).id), params: { user: { username: 'newFirstUser' } }
    assert_not_nil User.find_by(username: 'newFirstUser')
  end
end