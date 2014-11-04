module Sequel
  module Plugins
    module SequelDynamicColumn
      class Config
        attr_accessor :storage_column, :dynamic_columns

        def initialize(opts = {})
          @storage_column = opts[:storage_column] if opts.has_key?(:storage_column)
          @dynamic_columns = opts[:dynamic_columns] if opts.has_key?(:dynamic_columns)
        end
      end
    end
  end
end
