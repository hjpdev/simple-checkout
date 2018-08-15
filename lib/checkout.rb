require_relative 'item'

class Checkout
  attr_reader :receipt

  def initialize
    @receipt = []
    @total = 0
  end 

  def return_item_price(item)
    "£#{item.price}"
  end

  def scan(item, quantity=1)
    already_scanned(item.name) ? @receipt[item_index(item.name)][:quantity] += quantity : @receipt << { name: item.name, price: item.price, quantity: quantity }
  end

  def remove_item(item_name, quantity=1)
    raise 'Scanned quantity is less than the quantity specified' if quantity_of(item_name) < quantity
    @receipt[item_index(item_name)][:quantity] -= quantity
  end

  def total
    @receipt.map { |item| item[:price] * item[:quantity] }.inject('+')
  end

  private

    def quantity_of(item_name)
      @receipt.select { |item| item[:name] == item_name }.map { |i| i[:quantity] }.inject('+') 
    end

    def already_scanned(item_name)
      @receipt.map { |item| item[:name] }.include?(item_name)
    end

    def item_index(item_name)
      @receipt.index { |item| item[:name] == item_name }
    end
end

# co = Checkout.new
# apple = Item.new(:apple, 2)
# orange = Item.new(:orange, 1.5)
