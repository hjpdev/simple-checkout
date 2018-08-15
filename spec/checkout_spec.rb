require 'checkout'

describe Checkout do
  let(:apple) { double :item, name: :apple, price: 2 }
  let(:orange) { double :item, name: :orange, price: 1.5 }

  describe '#return_item_price' do

    it 'returns the price of an item, in the correct format' do
      expect(subject.return_item_price(apple)).to eq '£2'
    end
  end

  describe '#scan' do

    it 'scans an item and adds it to the receipt' do
      subject.scan(apple)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 1 }]
    end

    it 'scans one of the specified item by default' do
      subject.scan(apple)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 1 }]
    end

    it 'scans more than one of the same item if specified' do
      subject.scan(apple, 3)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 3 }]
    end

    it 'adds more of an item if scanned later' do
      subject.scan(apple, 3)
      subject.scan(orange, 3)
      subject.scan(apple, 3)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 6 }, { name: :orange, price: 1.5, quantity: 3 }]
    end
  end

  describe '#total' do

    it 'returns the total for items, when scanned individually' do
      subject.scan(apple)
      subject.scan(apple)
      expect(subject.total).to eq 4
    end

    it 'returns the total, when items are scanned in lots' do
      subject.scan(apple, 4)
      expect(subject.total).to eq 8
    end
  end

  describe '#remove_item' do
    
    it 'allows you to remove item from the receipt, given its name' do
      subject.scan(apple)
      subject.scan(apple)
      subject.scan(orange)
      subject.remove_item(:apple)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 1 }, { name: :orange, price: 1.5, quantity: 1 }]
    end

    it 'allows you to remove a certain number of an item' do
      subject.scan(apple, 3)
      subject.scan(orange, 2)
      subject.scan(apple, 4)
      subject.remove_item(:apple, 5)
      expect(subject.receipt).to eq [{ name: :apple, price: 2, quantity: 2 }, { name: :orange, price: 1.5, quantity: 2}]
    end

    it 'raises an error if you try to remove more of an item than has been scanned' do
      subject.scan(apple, 3)
      expect{subject.remove_item(:apple, 5)}.to raise_error('Scanned quantity is less than the quantity specified')
    end
  end
end