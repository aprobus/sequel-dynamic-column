module Sequel
  module Plugins
    module JsonWideRow
      module ClassMethods
        def full_columns
          basic_columns + json_extended_columns
        end

        def json_extended_columns
          @json_wide_row_config.extra_fields
        end

        def basic_columns
          columns - [@json_wide_row_config.json_column]
        end
      end
    end
  end
end
