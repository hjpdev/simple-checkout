class Checkout
  attr_reader :receipt

  def initialize
    @receipt = []
    @total = 0
  end 

  def return_price(item)
    "£#{item.price}"
  end

  def scan(item)
    @receipt << { name: item.name, price: item.price }
  end

  def total
    @receipt.map { |i| i[:price] }.inject('+')
  end
end