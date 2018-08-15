require 'terminal-table'
require_relative 'item'

class Checkout
  attr_reader :receipt, :log

  def initialize
    @receipt = []
  end 

  def return_item_price(item)
    "£#{item.price}"
  end

  def print_receipt
    table = Terminal::Table.new :headings => ['Item', 'Quantity'], :rows => items_with_quantity
  end

  def scan(item, quantity=1)
    already_scanned?(item.name) ? update_quantity(item.name, quantity) : @receipt << { item: item, quantity: quantity }
  end

  def remove_item(item_name, quantity=1)
    raise 'Item has not been scanned' if !already_scanned?(item_name)
    raise 'Scanned quantity is less than the quantity specified' if quantity_of(item_name) < quantity
    update_quantity(item_name, -quantity)
  end

  def total
    return 0 if @receipt.count == 0
    @receipt.map { |entry| entry[:item].price * entry[:quantity] }.inject('+')
  end

  private

    def quantity_of(item_name)
      @receipt.select { |entry| entry[:item].name == item_name }.map { |i| i[:quantity] }.inject('+') 
    end

    def items_with_quantity
      @receipt.map { |entry| [entry[:item].name, entry[:quantity]] }
    end

    def already_scanned?(item_name)
      @receipt.map { |entry| entry[:item].name }.include?(item_name)
    end

    def item_index(item_name)
      @receipt.index { |entry| entry[:item].name == item_name }
    end

    def update_quantity(item_name, quantity)
      @receipt[item_index(item_name)][:quantity] += quantity
    end
end