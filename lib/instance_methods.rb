module Sequel
  module Plugins
    module SequelDynamicColumn
      module InstanceMethods
        def to_extended_hash
          column_names = self.class.full_columns

          column_names.reduce({}) do |result, column_name|
            result[column_name] = self.send(column_name)
            result
          end
        end

        alias_method :extended_values, :to_extended_hash
      end
    end
  end
end
