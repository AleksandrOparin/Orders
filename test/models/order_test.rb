require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test 'empty order mustnt be saved' do
    order = Order.new
    refute order.save
  end

  test 'valid order should be saved' do
    order = orders(:one)
    assert order.save
  end

  test 'order without "cost" field shouldnt be saved' do
    order = orders(:two)
    order.cost = nil
    refute order.save
  end

  test 'order without "title" and "description" fields shouldnt be saved' do
    order = orders(:two)
    order.title = ''
    order.description = ''
    refute order.save
  end
end
