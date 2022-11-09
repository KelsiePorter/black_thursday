require_relative '../lib/item_repository'
require_relative '../lib/item'
require 'bigdecimal'

RSpec.describe ItemRepository do
  let(:ir) { ItemRepository.new }
  let(:item_1) do
    Item.new({
               id: 1,
               name: 'Pencil',
               description: 'You can use it to write things',
               unit_price: '1099',
               created_at: Time.now.round(2),
               updated_at: Time.now.round(2),
               merchant_id: 2
             })
  end

  let(:item_2) do
    Item.new({
               id: 2,
               name: 'Pen',
               description: 'You can use it to permanently write things',
               unit_price: '1299',
               created_at: Time.now.round(2),
               updated_at: Time.now.round(2),
               merchant_id: 7
             })
  end

  let(:item_3) do
    Item.new({
               id: 3,
               name: 'Stapler',
               description: 'Attaches pieces of paper together',
               unit_price: '1999',
               created_at: Time.now.round(2),
               updated_at: Time.now.round(2),
               merchant_id: 3
             })
  end

  let(:item_4) do
    Item.new({
               id: 4,
               name: 'Keyboard',
               description: 'Allows text input to a computer',
               unit_price: '2999',
               created_at: Time.now.round(2),
               updated_at: Time.now.round(2),
               merchant_id: 9
             })
  end

  let(:item_5) do
    Item.new({
               id: 5,
               name: 'Mouse',
               description: 'Moves the cursor around',
               unit_price: '2399',
               created_at: Time.now.round(2),
               updated_at: Time.now.round(2),
               merchant_id: 9
             })
  end

  describe '#initialize' do
    it 'exists' do
      expect(ir).to be_a(ItemRepository)
    end

    it 'starts with an empty array' do
      expect(ir.all).to eq([])
    end
  end

  describe '#add_to_repo()' do
    it 'adds items to @all' do
      expect(ir.all).not_to include(item_1)

      ir.add_to_repo(item_1)

      expect(ir.all).to include(item_1)

      ir.add_to_repo(item_2)

      expect(ir.all).to include(item_1, item_2)
    end
  end

  describe '#find_by_id()' do
    it 'finds an instance of Item with matching ID' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)

      expect(ir.find_by_id(4)).to eq(nil)
      expect(ir.find_by_id(1)).to eq(item_1)
    end
  end

  describe '#find_by_name()' do
    it 'finds an instance of Item with case insensitive search' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)

      expect(ir.find_by_name('Pen')).to eq(item_2)
    end
  end

  describe '#find_all_with_description()' do
    it 'finds an instance of Item using description' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)

      expect(ir.find_all_with_description('You can use it to write things')).to eq([item_1])
    end
  end

  describe '#find_all_by_price()' do
    it 'finds an instance of Item by price' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)

      expect(ir.find_all_by_price(12.99)).to eq([item_2])
    end
  end

  describe '#find_all_by_price_in_range()' do
    it 'finds an instance of Item with case insensitive search' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)
      ir.add_to_repo(item_3)
      ir.add_to_repo(item_4)

      expect(ir.find_all_by_price_in_range(19..30)).to eq([item_3, item_4])
      expect(ir.find_all_by_price_in_range(0..9)).to eq([])
      expect(ir.find_all_by_price_in_range(19.99..21.21)).to eq([item_3])
    end
  end

  describe '#find_all_by_merchant_by_id()' do
    it 'finds all instances of items by a merchant id' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)
      ir.add_to_repo(item_3)
      ir.add_to_repo(item_4)
      ir.add_to_repo(item_5)

      expect(ir.find_all_by_merchant_id(9)).to eq([item_4, item_5])
      expect(ir.find_all_by_merchant_id(5)).to eq([])
    end
  end

  describe '#max_id' do
    it 'returns a number one higher than current highest item ID, or 1 if no items in repo' do
      expect(ir.max_id).to eq(1)

      ir.add_to_repo(item_5)

      expect(ir.max_id).to eq(6)
    end
  end

  describe '#create(attributes)' do
    it 'creates a new Item instance with provided attributes' do
      expect(ir.all).to eq([])

      ir.add_to_repo(item_1)
      expect(ir.all.count).to eq(1)

      ir.create({
                  name: 'Eraser',
                  description: 'Erases pencil markings',
                  unit_price: BigDecimal(2.99, 4),
                  created_at: Time.now.round(2),
                  updated_at: Time.now.round(2),
                  merchant_id: 2
                })

      ir.create({
                  name: 'Scissors',
                  description: 'They cut things',
                  unit_price: BigDecimal(7.99, 4),
                  created_at: Time.now.round(2),
                  updated_at: Time.now.round(2),
                  merchant_id: 2
                })

      expect(ir.all[1].id).to eq(2)
      expect(ir.all[2].id).to eq(3)
      expect(ir.all[1].name).to eq('Eraser')
      expect(ir.all[2].name).to eq('Scissors')
      expect(ir.all[1]).to be_a(Item)
    end
  end

  describe '#update(id, attributes)' do
    it 'updates an items name, description, unit price and updated time' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)
      ir.add_to_repo(item_3)

      expect(ir.all.first.name).to eq('Pencil')
      expect(ir.all.first.unit_price).to eq(10.99)
      expect(ir.all.first.description).to eq('You can use it to write things')
      expect(ir.all.first.created_at).to eq(ir.all.first.updated_at)

      ir.update(1, {
                  name: 'Mechanical Pencil',
                  description: 'Writes things with replaceable lead',
                  unit_price: BigDecimal(5.99, 4)
                })

      expect(ir.all.first.name).to eq('Mechanical Pencil')
      expect(ir.all.first.unit_price).to eq(5.99)
      expect(ir.all.first.description).to eq('Writes things with replaceable lead')

      expect(ir.all.first.created_at).not_to eq(ir.all.first.updated_at)
    end
  end

  describe '#delete(id)' do
    it 'deletes an item from the all array' do
      ir.add_to_repo(item_1)
      ir.add_to_repo(item_2)
      ir.add_to_repo(item_3)

      expect(ir.all.count).to eq(3)

      ir.delete(1)
      expect(ir.all.count).to eq(2)
      expect(ir.all).to eq([item_2, item_3])

      ir.delete(3)
      expect(ir.all).to eq([item_2])
    end
  end
end
