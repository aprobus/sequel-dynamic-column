module Sequel
  module Plugins
    module SequelDynamicColumn
      module ClassMethods
        def full_columns
          basic_columns + dynamic_columns
        end

        def dynamic_columns
          @dynamic_column_config.dynamic_columns
        end

        def basic_columns
          columns - [@dynamic_column_config.storage_column]
        end
      end
    end
  end
end
