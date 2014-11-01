require 'spec_helper'

RSpec.describe Sequel::Plugins::JsonWideRow do
  describe 'config' do
    let(:fake_class) do
      class FakeClass < Sequel::Model
        plugin :json_wide_row, json_column: :my_json_column, extra_fields: [:a_field]
      end
      FakeClass
    end

    it 'sets json column' do
      expect(fake_class.json_wide_row_config.json_column).to eq(:my_json_column)
    end

    it 'sets json fields' do
      expect(fake_class.json_wide_row_config.extra_fields).to include(:a_field)
    end

    it 'adds getter for extra fields' do
      expect(fake_class.new).to respond_to (:a_field)
    end

    it 'adds setter for extra fields' do
      expect(fake_class.new).to respond_to (:a_field=)
    end
  end

  describe 'json_column' do
    let(:spice) { SpiceData.new }

    context 'json field' do
      it 'adds methods' do
        spice.price = 2
        expect(spice.price).to eq(2)
      end

      it 'stores on the json column' do
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
  end
end

