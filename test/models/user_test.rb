require "test_helper"

class UserTest < ActiveSupport::TestCase
  test 'empty user mustnt be saved' do
    user = User.new
    refute user.save
  end

  test 'valid user should be saved' do
    user = users(:one)
    assert user.save
  end

  test 'invalid user mustnt be saved' do
    user = users(:one)
    user.email = ''
    refute user.save
  end
end
