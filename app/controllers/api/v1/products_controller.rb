class Api::V1::ProductsController < Api::V1::ApiController
	  acts_as_token_authentication_handler_for User
	  before_action :set_product, only: [:show, :edit, :update, :destroy]
	  def index
	  	@products = Product.all
	  	json_response(@products)
	  end


	  def show
	  	json_response(@product)
	  end


	  def create
	  	@product = Product.new(product_params)
	  	if @product.save
	  		json_response(@product, :created)
	  	else
	  		json_response( @product.errors, status: :unprocessable_entity )
	  	end
	  end

	  def update
	  	if @product.update(product_params)
	  		json_response(@product, :created)
	  	else
	  		json_response( @product.errors, status: :unprocessable_entity )
	  	end
	  end

	  def destroy
	  	@product.destroy
	  	head :no_content 
	  end

	  private
	  def set_product
	  	@product = Product.find(params[:id])
	  end
	  def product_params
	  	params.require(:product).permit(:name, :price)
	  end
	end
