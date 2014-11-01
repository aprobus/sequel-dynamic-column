class SpiceData < Sequel::Model(:spices)
  plugin :json_wide_row, json_column: :json_fields, extra_fields: [:price]

end
