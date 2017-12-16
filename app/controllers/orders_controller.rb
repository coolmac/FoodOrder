class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :require_permission, only: [:show, :edit, :update, :destroy]
  def index
    @orders = current_user.orders.includes(:order_items).all
  end

  def show
  end

  def new
    @order = Order.new
    @order_items = @order.set_up_order_items
    @products = Product.all
  end

  def edit
    @order = Order.find(params[:id])
    @order_items = @order.set_up_order_items
  end

  def order_details
    @order = Order.new(order_params)
    render 'order_details', layout: false
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        @order_items = @order.set_up_order_items
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        @order_items = @order.set_up_order_items
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
     redirect_to(root_url, :notice => 'Record not found')
   end

    # Only owner can deal with his orders (athorise)
    def require_permission
      if current_user != @order.user
        redirect_to root_path, notice: "Not Athorised!"
      end
    end

    # White list order params
    def order_params
      params.require(:order).permit(:address, order_items_attributes: [:id, :quantity, :product_id])
    end
  end
