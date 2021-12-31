# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy take remove complete]
  skip_before_action :require_login, only: %i[index orders]

  def index; end

  def orders
    # All orders
    all_orders = Order.where(['worker_id is null and time_to_complete > ?',
                              Date.today]).as_json(only: %i[id title description cost time_to_complete user_id
                                                            worker_id complete])
    all_orders.map do |record|
      record['email'] = User.find(record['user_id']).email
      record['current_user'] = current_user ? current_user.id : 'none'
    end

    @orders = all_orders

    respond_to do |format|
      format.json { render json: @orders }
    end
  end

  def show; end

  def new
    @order = Order.new
  end

  def edit; end

  def create
    @order = Order.new(**order_params, user_id: current_user.id)

    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if current_user == @user && @order.update(order_params)
        format.html { redirect_to current_user, notice: t('.update_flash') }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: t('.destroy_flash') }
      format.json { head :no_content }
    end
  end

  def take
    @order.worker_id = current_user.id
    @order.save!
  end

  def remove
    @order.worker_id = nil
    @order.save!
  end

  def complete
    @order.complete = true
    @order.save!
  end

  def complete_orders
    # Complete orders
    complete_orders = Order.where(['worker_id = ? and complete = ?', current_user.id,
                                   true]).as_json(only: %i[id title description cost time_to_complete user_id worker_id
                                                           complete])
    complete_orders.map do |record|
      record['email'] = User.find(record['user_id']).email
      record['current_user'] = current_user.id
    end

    @orders = complete_orders

    render json: @orders
  end

  def take_orders
    # Selected orders
    select_orders = Order.where(['worker_id = ? and time_to_complete > ? and complete is null', current_user.id,
                                 Date.today]).as_json(only: %i[id title description cost time_to_complete user_id
                                                               worker_id complete])
    select_orders.map do |record|
      record['email'] = User.find(record['user_id']).email
      record['current_user'] = current_user.id
    end

    @orders = select_orders

    render json: @orders
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:title, :description, :cost, :time_to_complete)
  end
end
