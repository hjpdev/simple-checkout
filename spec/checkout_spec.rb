require 'checkout'

describe Checkout do
  let(:apple) { double :item, name: :apple, price: 2 }

  it 'returns the price of an item, in the correct format' do
    expect(subject.return_price(apple)).to eq '£2'
  end

  it 'scans an item and adds it to the receipt' do
    subject.scan(apple)
    expect(subject.receipt).to eq [{ name: :apple, price: 2 }]
  end

  it 'returns the total for all scanned items' do
    subject.scan(apple)
    subject.scan(apple)
    expect(subject.total).to eq 4
  end
end