require_relative 'config'
require_relative 'class_methods'
require_relative 'instance_methods'

module Sequel
  module Plugins
    module SequelDynamicColumn
      def self.configure(model, opts = {})
        #config = Config.new
        config = nil
        if block_given?
          config = Config.new
          yield config
        else
          config = Config.new(opts)
          #config.storage_column = opts.fetch(:storage_column)
          #config.dynamic_columns = opts.fetch(:dynamic_columns)
        end

        model.instance_eval do
          @dynamic_column_config = config

          class << self
            attr_accessor :dynamic_column_config
          end

          config.dynamic_columns.each do |field|
            field_str = field.to_s
            define_method "#{field}" do
              self.send(config.storage_column)[field_str]
            end

            define_method("#{field}=") do |val|
              storage_column_val = self.send(config.storage_column) || {}
              self.send("#{config.storage_column}=", storage_column_val)
              storage_column_val[field_str] = val
            end
          end
        end
      end
    end
  end
end
