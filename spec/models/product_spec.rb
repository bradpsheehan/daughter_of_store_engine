require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  
  # let!(:store){Store.new(name:'storename',path:'storepath',description:'desc',status:'active',theme:'metal')}
 
  let(:category){Category.new(store_id:1,title:'cat 1')}
  let(:category1){Category.new(store_id:1,title:'cat 1')}

  let(:product){Product.new}
  let(:product1){Product.new}

  let(:valid_product){Product.new(title:'title',description:'desc',price:12,status:'active',store_id:1)}

  it 'is invalid without a title' do
    p = product
    p.title = ''
    expect(p.save).to_not be
  end

  it 'is invalid without a description' do
    product.description = ''
    expect(product.save).to_not be
  end

  it 'is invalid if title already exists (case insensitive)' do
    valid_product.save
    product.title = 'title'
    expect(product.save).to_not be
  end

  it 'is invalid without a price' do
    valid_product.price = nil
    expect(valid_product.save).to_not be
  end

  it 'is invalid without a price greater than 0' do
    valid_product.price = 0
    expect(valid_product.save).to_not be
  end

  it 'is only valid with two or less decimal points' do
    valid_product.price = 0.123
    expect(valid_product.save).to_not be
  end

  it 'is invalid without a status' do
    valid_product.status = nil
    expect(valid_product.save).to_not be
  end

  it 'is invalid with a status other than active or retired' do
    valid_product.status = 'funky'
    expect(valid_product.save).to_not be
  end

  it 'has the ability to be assigned to multiple categories' do
    category.title = 'nicknacks'
    category1.title = 'paddywacks'
    category.save
    category1.save

    valid_product.categories = [category, category1]
    valid_product.save
    expect(valid_product.categories.count).to eq 2
  end

  describe '.toggle_status' do
    context 'on an active product' do
      it 'sets the status from active to retired' do
        valid_product.toggle_status
        expect(valid_product.status).to eq 'retired'
      end
    end

    context 'on a retired product' do
      it 'sets the statusto active' do
        valid_product.status = 'retired'
        valid_product.toggle_status
        expect(valid_product.status).to eq 'active'
      end
    end
  end
end
