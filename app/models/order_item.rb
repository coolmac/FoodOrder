class OrderItem < ApplicationRecord
	belongs_to :order, optional: true, inverse_of: :order_items
	belongs_to :product, optional: true, inverse_of: :order_items
	# validates_uniqueness_of :product_id, scope: :order_id, allow_nil: true
	validates :quantity, numericality: { only_integer: true, allow_nil: true }

	def quantity=(quantity)
		quantity.to_i <= 0 && !self.new_record? ?  self.destroy :  self[:quantity] = quantity
	end
	
	def total_items_price
	  self.quantity.to_i * self.product.try(:price).to_f
	end
end
