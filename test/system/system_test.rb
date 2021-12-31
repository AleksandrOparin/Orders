require "application_system_test_case"

class SystemTest < ApplicationSystemTestCase
  include SessionHelper

  setup do
    @user = users(:one)
  end

  test "visiting the root path" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test 'after login user should be redirected to root_path' do
    visit session_login_path
    fill_in 'login', with: users(:one).username
    fill_in 'password', with: 'Secret1'
    click_on 'submit-btn'
    sleep 1
    assert_selector 'h1', text: 'Orders'
  end

  test 'signed user can take orders and see it in the corresponding tab' do
    firstorder = orders(:one)
    firstorder.save

    secondorder = orders(:two)
    secondorder.save

    visit session_login_path
    fill_in 'login', with: users(:one).username
    fill_in 'password', with: 'Secret1'
    click_on 'submit-btn'
    sleep 2

    find('button[data-mdb-target="#flush-collapse0"]').click
    sleep 2

    find('button[data-take-order-id]').click
    sleep 2 

    find('#Tab-2').click
    sleep 2

    assert_selector 'button[data-mdb-target="#flush-collapse0"]'
  end

  test 'user can switch the language' do
    visit session_login_path
    fill_in 'login', with: users(:one).username
    fill_in 'password', with: 'Secret1'
    click_on 'submit-btn'

    find("#locale-btn", match: :first).click
    find("#ru", match: :first).click

    assert_selector 'h1', text: 'Заказы'
  end
end