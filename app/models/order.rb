class Order < ApplicationRecord
	belongs_to :user
	has_many :order_items
	has_many :products, -> { distinct }, through: :order_items
	accepts_nested_attributes_for :order_items, reject_if: proc { |attributes| attributes['quantity'].blank? && :new_record?  }
	
	 #order must contain atleast one product order
	 validates :order_items, presence: true
	 validates :address, presence: true

	 def set_up_order_items
	 	(Product.all - self.products).each do |product|
	 		self.order_items.build(:product => product)
	 	end
	 end 

	 def calculate_amount
	 	sum = 0
	 	self.order_items.each do |order_item|
	 		sum = sum + order_item.total_items_price
	 	end
	 	return sum
	 end
     
     before_validation :assign_amount

     private
     def assign_amount
     	self.amount = calculate_amount
     end

	end
