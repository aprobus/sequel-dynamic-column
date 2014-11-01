Sequel.migration do
  up do
    create_table :spices do
      primary_key :id
      String :name, null: false
      Json :json_fields
    end

    run "ALTER TABLE spices ALTER COLUMN json_fields SET DEFAULT '{}'::JSON"
  end

  down do
    drop_table :spices
  end
end
