class SpiceData < Sequel::Model(:spices)
  plugin :sequel_dynamic_column, storage_column: :json_fields, dynamic_columns: [:price]
end
