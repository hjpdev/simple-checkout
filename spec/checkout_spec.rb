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

    it 'scans an item, and adds one of it to the receipt by default' do
      subject.scan(apple)
      expect(subject.receipt).to eq [{ item: apple, quantity: 1 }]
    end

    it 'adds more than one of the item to the receipt if specified' do
      subject.scan(apple, 3)
      expect(subject.receipt).to eq [{ item: apple, quantity: 3 }]
    end

    it 'updates quantity of an item if scanned later' do
      subject.scan(apple, 3)
      subject.scan(orange, 3)
      subject.scan(apple, 3)
      expect(subject.receipt).to eq [{ item: apple, quantity: 6 }, { item: orange, quantity: 3 }]
    end
  end

  describe '#total' do

    it 'returns zero when nothing has been scanned' do
      expect(subject.total).to eq 0
    end

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

    context 'With 3 apples & 3 oranges already scanned' do
      before(:each) do
        subject.scan(apple, 3)
        subject.scan(orange, 3)
      end

      it 'allows you to remove item from the receipt, given its name' do
        subject.remove_item(:apple)
        expect(subject.receipt).to eq [{ item: apple, quantity: 2 }, { item: orange, quantity: 3 }]
      end
  
      it 'allows you to remove a certain number of an item' do
        subject.remove_item(:apple, 2)
        expect(subject.receipt).to eq [{ item: apple, quantity: 1 }, { item: orange, quantity: 3}]
      end

      it 'raises an error if you try to remove an item that hasn\'t been scanned' do
        expect{subject.remove_item(:banana)}.to raise_error('Item has not been scanned')
      end
  
      it 'raises an error if you try to remove more of an item than has been scanned' do
        expect{subject.remove_item(:apple, 5)}.to raise_error('Scanned quantity is less than the quantity specified')
      end
    end
  end
end