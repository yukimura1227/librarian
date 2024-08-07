# for order controller
class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :purchase]

  # GET /orders
  # GET /orders.json
  def index
    @q = Order.order(id: :desc).ransack(params[:q])
    @orders = @q.result.includes(:user).page(params[:page]).per(20)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.order_time = Time.zone.now
    @order.user = current_user

    respond_to do |format|
      validation_context = params[:ignore_title_unique_validation] == false.to_s ? :check_title_unique : nil
      if @order.save(context: validation_context)
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def extract_amazon_product_info
    @order = Order.new(order_params)
    @order.extract_amazon_product_info!
  end

  def purchase
    if @order.purchase
      redirect_to books_path, notice: 'Order was successfully purchased.'
    else
      redirect_to orders_path, alert: 'Error!! Order was not purchased.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:title, :order_time, :state, :url, :origin_html, :image_path)
  end
end
