require 'item'

describe Item do
  apple = Item.new(:apple, 2)

  it 'initialises with an item name' do
    expect(apple.name).to eq :apple
  end

  it 'initialises with a price' do
    expect(apple.price).to eq 2
  end
end