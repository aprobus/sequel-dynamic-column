require 'spec_helper'

RSpec.describe Sequel::Plugins::SequelDynamicColumn do
  describe 'config' do
    context 'hash' do
      let(:fake_class) do
        class FakeClass < Sequel::Model
          plugin :sequel_dynamic_column, storage_column: :my_json_column, dynamic_columns: [:a_field]
        end
        FakeClass
      end

      it 'sets storage column' do
        expect(fake_class.dynamic_column_config.storage_column).to eq(:my_json_column)
      end

      it 'sets dynamic columns' do
        expect(fake_class.dynamic_column_config.dynamic_columns).to include(:a_field)
      end

      it 'adds getter for extra fields' do
        expect(fake_class.new).to respond_to (:a_field)
      end

      it 'adds setter for extra fields' do
        expect(fake_class.new).to respond_to (:a_field=)
      end
    end

    context 'block' do
      let(:fake_class) do
        class FakeClass2 < Sequel::Model
          plugin :sequel_dynamic_column do |c|
            c.storage_column  = :my_json_column
            c.dynamic_columns = :a_field, :b_field
          end
        end
        FakeClass2
      end

      it 'sets storage column' do
        expect(fake_class.dynamic_column_config.storage_column).to eq(:my_json_column)
      end

      it 'sets dynamic columns' do
        expect(fake_class.dynamic_column_config.dynamic_columns).to include(:a_field, :b_field)
      end

      it 'adds getter for extra fields' do
        expect(fake_class.new).to respond_to (:a_field)
      end

      it 'adds setter for extra fields' do
        expect(fake_class.new).to respond_to (:a_field=)
      end
    end
  end

  describe 'getters/setters' do
    let(:spice) { SpiceData.new }

    it 'adds methods' do
      spice.price = 2
      expect(spice.price).to eq(2)
    end

    it 'stores on the storage column' do
      spice.price = 2
      expect(spice.json_fields['price']).to eq(2)
    end

    it 'stores and loads variables' do
      spice.name = 'curry'
      spice.price = 2
      spice.save

      loaded_spice = SpiceData.where(id: spice.id).first
      expect(loaded_spice.price).to eq(2)
    end
  end

  describe '.basic_columns' do
    it 'excludes json columns' do
      result = SpiceData.basic_columns

      expect(result.length).to eq(2)
      expect(result).to include(:id, :name)
    end
  end

  describe '.dynamic_columns' do
    it 'only includes dynamic columns' do
      result = SpiceData.dynamic_columns

      expect(result.length).to eq(1)
      expect(result).to include(:price)
    end
  end

  describe '.full_columns' do
    it 'includes basic and json extended columns' do
      result = SpiceData.full_columns

      expect(result.length).to eq(3)
      expect(result).to include(:id, :name, :price)
    end
  end

  describe '#to_extended_hash' do
    it 'includes basic and dynamic columns' do
      result = SpiceData.new(name: 'curry', price: 5).to_extended_hash

      expect(result).to eq({ id: nil, name: 'curry', price: 5 })
    end
  end

  describe '#extended_values' do
    it 'includes basic and dynamic columns' do
      result = SpiceData.new(name: 'curry', price: 5).extended_values

      expect(result).to eq({ id: nil, name: 'curry', price: 5 })
    end
  end
end
