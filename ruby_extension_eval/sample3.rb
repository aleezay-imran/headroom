class OrderValidator
  MAX_ITEMS = 50

  def initialize(order)
    @order = order
    @errors = []
  end

  def valid?
    check_items
    check_total
    check_shipping_address
    @errors.empty?
  end

  def check_items
    if @order.items.empty?
      @errors << "Order must have at least one item"
    end
    if @order.items.length > MAX_ITEMS
      @errors << "Order exceeds maximum item count"
    end
  end

  def check_total
    calculated = @order.items.sum { |item| item.price * item.quantity }
    if calculated != @order.total
      @errors << "Order total mismatch"
    end
  end

  def check_shipping_address
    unless @order.shipping_address&.valid?
      @errors << "Invalid shipping address"
    end
  end
end
